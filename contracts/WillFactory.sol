//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WillFactory {

    event NewWill(address, address);

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }

    function buildWill(address willUser, uint256 expiration) public payable {
        Will w = new Will(willUser, expiration);
        console.log(address(w));
        emit NewWill(willUser, address(w));
    }
}

contract Will {
    address public willUser;
    address public builderDao = 0x0000000000000000000000000000000000000001;
    uint256 public expiration;
    address[] private _guardians;
    
    struct guardianData {
        bool isGuardian; 
    }

    mapping(address => guardianData) public guardianInfo;

    modifier onlyOwner() {
        require (msg.sender == willUser, "Unauthorized");
        _;
    }

    modifier expiredCheck() {
        require (isExpired() == false, "Already Expired");
        _;
    }

    constructor(address _willUser, uint256 _expiration) {
        willUser = _willUser;
        expiration = block.timestamp + _expiration; // @TODO refactor -manny
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

    // ***
    function ownershipTransfer(address _guardian, address superGuardian) external {
        guardianData storage _guardianA = guardianInfo[_guardian];
        require (isExpired() == true, "Not Expired");
        require(_guardianA.isGuardian, "Not Guardian");
        superGuardian = _guardian;
        finalizeWill(superGuardian);
    }

    // ***
    function finalizeWill(address superGuardian) private {
//        require (isExpired() == true, "Not Expired");
        require (msg.sender == superGuardian, "Not guardian");
        uint commissionAmount = address(willUser).balance * 2 / 100;
        payCommission(commissionAmount);
        sendAssets(superGuardian);
        getBalance();
    }

    // 
    function sendAssets(address superGuardian) private {
        console.log("Sending willUser balance to guardians:", address(willUser).balance);
        (bool sent, bytes memory data) = superGuardian.call{value: address(willUser).balance}("");
        require(sent, "Failed to send Ether");
        getBalance();
    }

    function payCommission(uint commissionAmount) private {     
        console.log("Paying the commission of amount %s ", commissionAmount);
        (bool sent, bytes memory data) = builderDao.call{value: commissionAmount}("");
        require(sent, "Failed to send Ether");      
        getBalance(); 
    }
}