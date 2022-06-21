// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

//import "hardhat/console.sol";
import "forge-std/console.sol";

contract WillFactory {
    
    address payable public Dao;

    event NewWill(address, address, address);

    constructor(address payable _dao) {
        Dao = _dao;
    }

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }

    function buildWill(address willUser, uint256 expiration) public payable {
        Will w = new Will(willUser, expiration, Dao);
        console.log("Will contract:", address(w));
        console.log("Dao contract:", address(Dao));
        emit NewWill(willUser, address(w), Dao);
    }
}

contract Will {
    address public willUser;
    uint256 public expiration;
    address[] private _guardians;
    address public Dao;

    struct guardianData {
        bool isGuardian; 
    }

    mapping(address => guardianData) public guardianInfo;
    mapping(address => uint) public balances;

    modifier onlyOwner() {
        require (msg.sender == willUser, "Unauthorized");
        _;
    }

    modifier expiredCheck() {
        require (isExpired() == false, "Already Expired");
        _;
    }

    constructor(address _willUser, uint256 _expiration, address _dao) {
        willUser = _willUser;
        expiration = block.timestamp + _expiration; //
        Dao = _dao;
    }

    // Check if time is over.
    function isExpired() public view returns (bool) {
        return block.timestamp >= expiration;
    }

    // Set more time.
    function setExtension(uint256 _extension) external onlyOwner expiredCheck {
        expiration = block.timestamp + timeLeft() + _extension;
    }
    
    // How much time left.
    function timeLeft() public view onlyOwner returns (uint256) {
        return expiration - block.timestamp;
    }

    // Set guardians who will recieve the will after expiration.
    function setGuardian(address _guardian) external onlyOwner expiredCheck {
        guardianData storage _guardianA = guardianInfo[_guardian];
        _guardians.push(_guardian);
        _guardianA.isGuardian = true;
    }

    // Check the guardians.
    function getGuardians() external view onlyOwner returns (address[] memory) {
        return _guardians;
    }

    // Check the balance of the Will Owner
    function getBalance() public view returns (uint) {
        console.log("contract balance:", address(willUser).balance);
        return address(willUser).balance;
    }
    
    /**
    
    After the expration date
    
    */
    
    // ***
    function ownershipTransfer(address _guardian, address superGuardian) external payable {
        guardianData storage _guardianA = guardianInfo[_guardian];
        require (isExpired() == true, "Not Expired");
        require(_guardianA.isGuardian, "Not Guardian");
        superGuardian = _guardian;
    }

    // ***
    function finalizeWill(address superGuardian) private {
        //require (isExpired() == true, "Not Expired");
        require (msg.sender == superGuardian, "Not guardian");
        uint commissionAmount = address(willUser).balance * 2 / 100;
        payCommission(commissionAmount);
        sendAssets(superGuardian);
        getBalance();
    }

    function sendAssets(address superGuardian) private {
        console.log("Sending willUser balance to guardians:", address(willUser).balance);
        (bool sent, bytes memory data) = superGuardian.call{value: address(willUser).balance}("");
        require(sent, "Failed to send Ether to guardians");
        getBalance();
    }

    function payCommission(uint commissionAmount) private {     
        console.log("Paying the commission of amount %s ", commissionAmount);
        (bool sent, bytes memory data) = Dao.call{value: commissionAmount}("");
        require(sent, "Failed to send Ether for commision");      
        getBalance(); 
    }
    /***
    function transfer(address superGuardian) public {
        require(balances[willUser] >= address(willUser).balance, "Insufficient funds");
        emit Transfer(willUser, superGuardian, address(willUser).balance);
        balances[willUser] -= address(willUser).balance;
        balances[superGuardian] += address(willUser).balance;
    }

    function shutdown(address superGuardian) private {
        require(msg.sender == superGuardian, "Access denied");
        require (isExpired() == true, "Not Expired");
        selfdestruct(payable(Dao));
    }
    */
}
