// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {OperatorsExample} from "../src/2 - operators.sol";

contract OperatorsTest is Test {
    OperatorsExample public operatorsExample;

    function setUp() public {
        operatorsExample = new OperatorsExample();
    }

    function testCalculateAVG() public view {
        uint256 result = operatorsExample.calculateAVG(10, 20);
        assertEq(result, 15);
    }

    function testMultiply() public view {
        uint256 result = operatorsExample.multiply(10, 20);
        assertEq(result, 200);
    }

    function testSum() public view {
        uint256 result = operatorsExample.sum(10, 20);
        assertEq(result, 30);
    }

    function testSumUsingOpcode() public view {
        uint256 result = operatorsExample.sumUsingOpcode(10, 20);
        assertEq(result, 30);
    }

    function testCheckBoolean() public view {
        bool result = operatorsExample.checkBoolean(true, true);
        assertEq(result, true);
    }

    function testSetValue() public {
        uint256 result = operatorsExample.setValue(10);
        assertEq(result, 10);
    }

    function testEmitDriveLicense() public view {
        string memory result = operatorsExample.emitDriveLicense(
            18,
            "John Doe"
        );
        assertEq(result, "Your drive is good, John Doe");
    }
}
