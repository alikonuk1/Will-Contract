// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "src/Will.sol";

contract WillTest is Test {
    Will public will;

    address internal owner;
    address internal guardian;
    uint256 internal timeleft;

    function setUp() public {
        owner = address(0xB0B);
        guardian = address(0xA11ce);

        will = new Will(owner, 60);
        
        //top up the owner account with ETH
        owner.call{value: 90 ether}("");
    }

    function test_SetGuardian() public {
        vm.prank(owner);

        will.setGuardian(address(guardian));

        emit log_address(address(guardian));

        assertEq(address(guardian), guardian);
    }

    function test_SetExtension() public {
        vm.startPrank(owner);
        emit log("Time left before extending:");
        emit log_uint(will.timeLeft());

        timeleft = will.timeLeft();

        will.setExtension(100);

        emit log("Time left after extending:");
        emit log_uint(will.timeLeft());

        assertEq(will.timeLeft(), timeleft + 100);
    }

    function test_SetGetKey() public {
        vm.startPrank(owner);

        will.setKey(0x150cf01dc6845a9342f9700b02ad538d8b0e0b7c950131b199c5debcce988be5);
        will.setKey(0x155cf01dc6845a9342f9700b02ad538d8b0e0b7c950131b199c5debcce988be5);

        vm.stopPrank();
    }
}
