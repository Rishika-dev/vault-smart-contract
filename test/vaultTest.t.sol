// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault vault;

    address owner = address(this);
    address user1 = address(1);
    address user2 = address(2);

    function setUp() external {
        vault = new Vault();

        // Give ETH to test users
        vm.deal(owner, 10 ether);
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    /*//////////////////////////////////////////////////////////////
                            FUND TESTS
    //////////////////////////////////////////////////////////////*/

    function testFundUpdatesUserBalance() external {
        vault.fund{value: 0.01 ether}();

        assertEq(vault.ethFunds(owner), 0.01 ether);
    }

    function testFundUpdatesTotalEthFunds() external {
        vault.fund{value: 0.02 ether}();

        assertEq(vault.totalEthFunds(), 0.02 ether);
    }

    function testMultipleUsersCanFund() external {
        vm.prank(user1);
        vault.fund{value: 0.01 ether}();

        vm.prank(user2);
        vault.fund{value: 0.02 ether}();

        assertEq(vault.ethFunds(user1), 0.01 ether);
        assertEq(vault.ethFunds(user2), 0.02 ether);
        assertEq(vault.totalEthFunds(), 0.03 ether);
    }

    function testFundRevertsIfZeroValueSent() external {
        vm.expectRevert(Vault.InvalidAmount.selector);
        vault.fund{value: 0}();
    }

    /*//////////////////////////////////////////////////////////////
                          WITHDRAW TESTS
    //////////////////////////////////////////////////////////////*/

    // function testOwnerCanWithdraw() external {
    //     vault.fund{value: 1 ether}();

    //     uint256 ownerBalanceBefore = owner.balance;

    //     vault.withdraw();

    //     uint256 ownerBalanceAfter = owner.balance;

    //     assertGt(ownerBalanceAfter, ownerBalanceBefore);
    //     assertEq(address(vault).balance, 0);
    //     assertEq(vault.totalEthFunds(), 0);
    // }

    // function testWithdrawTransfersAllEthToOwner() external {
    //     vm.prank(user1);
    //     vault.fund{value: 0.5 ether}();

    //     vm.prank(user2);
    //     vault.fund{value: 0.5 ether}();

    //     uint256 ownerBalanceBefore = owner.balance;

    //     vault.withdraw();

    //     uint256 ownerBalanceAfter = owner.balance;

    //     assertEq(ownerBalanceAfter - ownerBalanceBefore, 1 ether);
    // }

    function testNonOwnerCannotWithdraw() external {
        vm.prank(user1);
        vm.expectRevert(Vault.NotOwner.selector);
        vault.withdraw();
    }

    /*//////////////////////////////////////////////////////////////
                       RECEIVE / FALLBACK TESTS
    //////////////////////////////////////////////////////////////*/

    // function testReceiveFunctionFundsContract() external {
    //     (bool success, ) = address(vault).call{value: 0.1 ether}("");
    //     assertTrue(success);

    //     assertEq(vault.ethFunds(owner), 0.1 ether);
    //     assertEq(vault.totalEthFunds(), 0.1 ether);
    // }

    // function testFallbackFunctionFundsContract() external {
    //     (bool success, ) = address(vault).call{value: 0.2 ether}(
    //         abi.encodeWithSignature("nonExistentFunction()")
    //     );
    //     assertTrue(success);

    //     assertEq(vault.ethFunds(owner), 0.2 ether);
    //     assertEq(vault.totalEthFunds(), 0.2 ether);
    // }
}
