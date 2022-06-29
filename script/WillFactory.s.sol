// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {WillFactory} from "src/WillFactory.sol";

contract WillFactoryScript is Script {
    function setUp() public {}

    address payable Dao;

    function run() public {
        vm.broadcast();
        new WillFactory(Dao);
    }

}
