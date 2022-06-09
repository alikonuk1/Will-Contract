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
    uint256 public expiration;
    address[] private _guardians;



    constructor(address _willUser, uint256 _expiration) {
        willUser = _willUser;
        expiration = block.timestamp + _expiration; // @TODO refactor -manny
    }

    // Check if time is over.
    function isExpired() public view returns (bool) {
        return block.timestamp >= expiration;
    }

    // Set more time.
    function setExtension(uint256 _extension) external {
        expiration = block.timestamp + _extension;
    }
    
    // How much time left.
    function timeLeft() public view returns (uint256) {
        return expiration - block.timestamp;
    }

    // Set guardians who will recieve the will after expiration.
    function setGuardian(address _guardian) external {
        _guardians.push(_guardian);
    }

    // Check the guardians.
    function getGuardians() external view returns (address[] memory) {
        return _guardians;
    }

    // Check the balance of the Will Owner
    function getBalance() public view returns (uint) {
        console.log("contract balance:", address(willUser).balance);
        return address(willUser).balance;
    }
/*
    function finalizeWill() private {
//        uint commissionAmount = address(willUser).balance * 2 / 100;
//        payCommission(commissionAmount);
        sendAssets(guardians);
        //getBalance();
    }

    // 
    function sendAssets() private {
        console.log("Sending guardians the balance of willUser:", address(willUser).balance);
        (bool sent, bytes memory data) = guardians.call{value: address(willUser).balance}("");
        require(sent, "Failed to send Ether");
        //getBalance();
    }
/*
    function payCommission(uint commissionAmount) private {     
        console.log("Paying the commission of amount %s ", commissionAmount);
        (bool sent, bytes memory data) = alikonuk.call{value: commissionAmount}("");
        require(sent, "Failed to send Ether");      
        //getBalance(); 
    }
*/
}