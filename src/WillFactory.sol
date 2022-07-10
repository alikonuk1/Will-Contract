// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/console.sol";

import "./Will.sol";

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