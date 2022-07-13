// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "src/Will.sol";

import "./utils/MockERC20.sol";

contract WillTest is Test {
    Will public will;
    MockERC20 internal token;

    address internal owner;
    address internal guardian;
    address internal dao;
    uint256 internal timeleft;

    function setUp() public {
        owner = address(0xB0B);
        guardian = address(0xA11ce);
        dao = address(0xDA0);
        
        token = new MockERC20();
        will = new Will(owner, 60, dao);
        
        //top up the owner account with Tokens
        token.mint(owner, 100e18);
        
        //top up the owner account with ETH
        owner.call{value: 90 ether}("");
    }

    function test_OwnerTokenBalance() public {
        emit log("Owner balance of MockERC20:");
        emit log_uint(token.balanceOf(owner));

        assertEq(token.balanceOf(owner), 100e18);
    }

    function test_SetGuardian() public {
        vm.prank(owner);

        will.setGuardian(address(guardian));

        emit log_address(address(guardian));

        assertEq(address(guardian), guardian);
    }

    function test_DepositEther() public {
        vm.startPrank(owner);

        emit log("owner balance before transfer:");
        emit log_uint(address(owner).balance);

        address(will).call{value: 9 ether}(abi.encode(address(owner)));
        
        emit log("owner balance after transfer:");
        emit log_uint(address(owner).balance);
        emit log("contract balance:" );
        emit log_uint(address(will).balance);

        assertEq(address(will).balance, 9 ether);
        vm.stopPrank();
    }

    function test_DepositTokens() public {
        vm.startPrank(owner);

        emit log("Contract token balance before deposit:");
        emit log_uint(token.balanceOf(address(will)));

        token.transfer(address(will), 100e18);

        emit log("Contract token balance after deposit:");
        emit log_uint(token.balanceOf((address(will))));

        assertEq(token.balanceOf((address(will))), 100e18);

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

    function testFail_GuardianWithdrawETHBeforeExpiration() public {
        vm.startPrank(owner);
        //set guardian
        will.setGuardian(address(guardian));
        //deposit eth to the will contract as owner
        address(will).call{value: 9 ether}(abi.encode(address(owner)));
        vm.stopPrank();

        vm.startPrank(guardian);
        emit log("Contract balance before withdraw:");
        emit log_uint(address(will).balance);    

        emit log("Guardian balance before withdraw:");
        emit log_uint(address(guardian).balance);

        will.withdrawETH();
        //these will show if testfail fails, will not show if it passes
        emit log("Guardian balance after withdraw:");
        emit log_uint(address(guardian).balance);
    }

    function testFail_GuardianWithdrawTokenBeforeExpiration() public {
        vm.startPrank(owner);
        //set guardian
        will.setGuardian(address(guardian));
        //deposit tokens to the will contract as owner
        token.transfer(address(will), 100e18);
        vm.stopPrank();

        vm.startPrank(guardian);
        emit log("Contract balance before withdraw:");
        emit log_uint(token.balanceOf(address(will)));    

        emit log("Guardian balance before withdraw:");
        emit log_uint(token.balanceOf(address(guardian)));

        will.withdrawTokens(address(token));
        //these will show if testfail fails, will not show if it passes
        emit log("Guardian balance after withdraw:");
        emit log_uint(token.balanceOf(address(guardian)));
    }
    
    function test_GuardianWithdrawETHAfterExpiration() public {
        vm.startPrank(owner);
        will.setGuardian(address(guardian));
        emit log("Time left:");
        emit log_uint(will.timeLeft());
        address(will).call{value: 9 ether}(abi.encode(address(owner)));
        emit log("ETH balance of contract:");
        emit log_uint(address(will).balance);
        vm.stopPrank();

        vm.warp(61);
        vm.startPrank(owner);
        emit log("Time left:");
        emit log_uint(will.timeLeft());
        vm.stopPrank();
        vm.roll(3);

        assertEq(will.isExpired(), true);

        vm.startPrank(guardian); 
        will.withdrawETH();
        emit log("Guardian ETH balance after withdraw");
        emit log_uint(address(guardian).balance);
        vm.stopPrank();

        assertEq(address(guardian).balance, 9 ether);
    }

    function test_GuardianWithdrawTokenAfterExpiration() public {
        vm.startPrank(owner);
        will.setGuardian(address(guardian));
        emit log("Time left:");
        emit log_uint(will.timeLeft());
        address(will).call{value: 9 ether}(abi.encode(address(owner)));
        token.transfer(address(will), 100e18);
        emit log("Token balance of contract:");
        emit log_uint(token.balanceOf(address(will)));
        vm.stopPrank();

        vm.warp(61);
        vm.startPrank(owner);
        emit log("Time left:");
        emit log_uint(will.timeLeft());
        vm.stopPrank();
        vm.roll(3);

        assertEq(will.isExpired(), true);

        token.approve(address(will), 100e18);

        vm.startPrank(guardian); 
        will.withdrawTokens(address(token));
        emit log("Guardian Token balance after withdraw");
        emit log_uint(token.balanceOf(address(guardian)));
        vm.stopPrank();

        assertEq(token.balanceOf(address(guardian)), 100e18);
    }

}
