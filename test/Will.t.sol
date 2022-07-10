// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "src/Will.sol";

import "./utils/MockERC20.sol";

contract WillTest is Test {
    Will will;
    MockERC20 internal token;

    address internal owner;
    address internal guardian;
    address internal dao;

    function setUp() public {
        owner = address(0xB0B);
        guardian = address(0xA11ce);
        dao = address(0xDA0);
        
        token = new MockERC20();
        will = new Will(owner, 60, dao);

        token.mint(owner, 100e18);
    }

    function testOwnerTokenBalance() public {
        assertEq(token.balanceOf(owner), 100e18);
    }

    function testSetGuardian() public {
        vm.prank(owner);

        will.setGuardian(address(guardian));

        assertEq(address(guardian), guardian);
    }

    function testDepositEther() public {
        vm.prank(owner);

        will.depositEther{value: 9 ether}();

        assertEq(address(will).balance, 9 ether);
    }
}
