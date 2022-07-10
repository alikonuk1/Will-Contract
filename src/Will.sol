// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/console.sol";

import "./lib/IERC20.sol";
import "./lib/SafeERC20.sol";

contract Will {

    using SafeERC20 for IERC20;

    address public willUser;
    uint256 public expiration;
    address public guardian;
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

    modifier onlyGuardian() {
        require (msg.sender == guardian, "Unauthorized");
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

/*    Time    */

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

/*    Guardians    */

    // Set guardians who will recieve the will after expiration.
    function setGuardian(address _guardian) external onlyOwner expiredCheck {
        guardian = _guardian;
    }

    // Check the guardian.
    function getGuardian() external view onlyOwner returns(address) {
        return guardian;
    }

/*    Assets    */

    // Check ETH balance of the contract
    function getBalance() public view returns (uint) {
        console.log("contract balance:", address(this).balance);
        return address(this).balance;
    }
    
    // Deposit ETH
    function depositEther() external payable {
    }

    // Check ERC20 balance of the contract
    function getTokenBalance(address _token) public view returns(uint256){ 
       IERC20 token = IERC20(_token);
       return token.balanceOf(address(this));// balancdOf function is already declared in ERC20 token function
    }

    // Deposit ERC20 Tokens
    function depositTokens(address _token, uint256 _tokenamount) public payable {
        IERC20 token = IERC20(_token);
        token.approve(address(this), _tokenamount);
        token.safeTransferFrom(msg.sender, address(this), _tokenamount);
    }

    /**
    
    After the expration date
    
    */
/*
    // Transfer the ownership and finalize
    function ownershipTransfer(address _guardian, address superGuardian, address _token) external payable {
        guardianData storage _guardianA = guardianInfo[_guardian];
        require (isExpired() == true, "Not Expired");
        require(_guardianA.isGuardian, "Not Guardian");
        superGuardian = _guardian;
        finalizeWill(superGuardian, _token);
    }
*/
/*    Assets    */
    
    // 
    function withdrawETH() external {
        console.log("Sending ETH balance to guardians:", address(this).balance);
        (bool sent, ) = guardian.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether to guardians");
        getBalance();
    }
/*    
    // Pay commission as ETH
    function payCommission(uint commissionAmount) private {     
        console.log("Paying the ETH commission of amount %s ", commissionAmount);
        (bool sent, ) = Dao.call{value: commissionAmount}("");
        require(sent, "Failed to send Ether for commision");      
        getBalance(); 
    }
*/

/*    Withdraw ERC20 Tokens    */
// @TODO - Make it transfer without specifying token 
//
    function withdrawTokens(address _token) external {
        IERC20 token = IERC20(_token);
        uint256 _tokenamount = token.balanceOf(address(this));
        console.log("Withdrawing Token balance of:", _tokenamount);
        token.safeTransferFrom(address(this), guardian, _tokenamount);
    }
/*
    // Pay commission as ERC20
    function payTCommission(uint commissionTAmount, address _token) private {     
        IERC20 token = IERC20(_token);
        console.log("Paying the Token commission of amount %s ", commissionTAmount);
        token.safeTransferFrom(address(this), payable(Dao), commissionTAmount);
    }
*/

/**
    function shutdown(address superGuardian) private {
        require(msg.sender == superGuardian, "Access denied");
        require (isExpired() == true, "Not Expired");
        selfdestruct(payable(Dao));
    }
*/
}
