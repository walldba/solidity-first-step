// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {InheritanceExample} from "../src/7 - inheritance.sol";

contract InheritanceTest is Test {
    InheritanceExample public inheritanceExample;
    string constant NAME = "Test Inheritance";

    function setUp() public {
        inheritanceExample = new InheritanceExample(NAME);
    }

    function testConstructorInitialization() public {
        assertEq(inheritanceExample.name(), NAME);
    }

    function testMakeSound() public {
        string memory sound = inheritanceExample.makeSound();
        assertEq(sound, "Buy Coin");
    }
}
