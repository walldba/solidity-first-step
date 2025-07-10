// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {constructorExample} from "../src/5 - constructors.sol";

contract ConstructorTest is Test {
    constructorExample public constructorContract;
    string constant NAME = "Test Name";
    uint256 constant AGE = 25;
    address constant OWNER = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function setUp() public {
        constructorContract = new constructorExample(NAME, AGE);
    }

    function testConstructorInitialization() public {
        assertEq(constructorContract.name(), NAME);
        // Since age is immutable, there's no public getter
    }

    function testSetNameAsOwner() public {
        string memory newName = "New Name";
        
        // Impersonate the owner address
        vm.prank(OWNER);
        constructorContract.setName(newName);
        
        assertEq(constructorContract.name(), newName);
    }
    
    function testSetNameNotOwner() public {
        string memory newName = "New Name";
        address nonOwner = address(1);
        
        // Impersonate a non-owner address
        vm.prank(nonOwner);
        
        // This should revert with the error message
        vm.expectRevert("Only the owner can call this method");
        constructorContract.setName(newName);
    }
}
