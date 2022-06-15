// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "src/WillFactory.sol";
import "./Utilities.t.sol";

contract BaseTest is Test {
       
    WillFactory willFactory;
    Will will;

    Utilities utilities;
    
    address willUser;
    address guardian;
    address user;

    function setUp() public virtual {
        
        utilities = new Utilities();

        address payable[] memory users = utilities.createUsers(3);
        willUser = users[0];
        guardian = users[1];
        user = users[2];

        // owner is the user deploying the Will contract
        vm.prank(willUser);
        will = new Will();

        assertEq(will.willUser(), willUser);
        assertEq(will.expiration(), 0);

    }
}
