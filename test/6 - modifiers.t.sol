// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ModifierExamples} from "../src/6 - modifiers.sol";

contract ModifierTest is Test {
    ModifierExamples public modifierExample;
    address deployer;

    function setUp() public {
        deployer = address(this);
        modifierExample = new ModifierExamples();
    }

    function testOwnerInitialization() public view {
        assertEq(modifierExample.owner(), deployer);
    }

    function testChangeOwnerAsOwner() public {
        address newOwner = address(0x123);

        modifierExample.changeOwner(newOwner);

        assertEq(modifierExample.owner(), newOwner);
    }

    function test_Revert_When_FailChangeOwnerNotOwner() public {
        address nonOwner = address(0x456);
        address newOwner = address(0x789);

        vm.prank(nonOwner);

        vm.expectRevert("Invalid Owner");
        modifierExample.changeOwner(newOwner);
    }

    function test_Revert_When_FailChangeOwnerToZeroAddress() public {
        address zeroAddress = address(0);

        vm.expectRevert("Invalid address!");
        modifierExample.changeOwner(zeroAddress);
    }

    function testLockedState() public view {
        assertEq(modifierExample.locked(), false);
    }
}
