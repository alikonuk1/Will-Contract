// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "src/WillFactory.sol";
import "./Utilities.t.sol";

contract BaseTest is Test {
       
    WillFactory willFactory;
    Will will;

    Utilities utilities;
    
    address factoryOwner;
    address willUser;
    address guardian;
    address user;

    function setUp() public virtual {
        
        utilities = new Utilities();

        address payable[] memory users = utilities.createUsers(3);
        factoryOwner = users[0];
        willUser = users[1];
        guardian = users[2];
        randomUser = users[3];

        // 
        vm.prank(factoryOwner);
        willFactory = new WillFactory();

        assertEq(will.willUser(), willUser);
        assertEq(will.expiration(), 0);

    }
}
