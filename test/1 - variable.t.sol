// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Test} from "forge-std/Test.sol";
import {VariableExamples} from "../src/1 - variable.sol";

contract VariableTest is Test {
    VariableExamples public variableExamples;

    function setUp() public {
        variableExamples = new VariableExamples();
    }

    function test_changePermition() public {
        variableExamples.changePermition(true);
        assertEq(variableExamples.permition(), true);
    }

    function test_registerAddresss() public {
        variableExamples.registerAdress(address(1));
        assertEq(variableExamples.registredAddress(), address(1));
    }

    function test_registerMyAdress() public {
        string memory testName = "Test User";
        address sender = address(this);
        vm.startPrank(sender);
        variableExamples.registerMyAdress(testName);
        vm.stopPrank();

        assertEq(variableExamples.registredAddress(), sender);
        assertEq(variableExamples.name(), testName);
    }

    function test_armazenarDados() public {
        variableExamples.armazenarDados(bytes("test data"));
        assertEq(variableExamples.meusBytes(), bytes("test data"));
    }

    function test_convertStringToBytes() public view {
        string memory phrase = "Hello World";
        bytes32 expected = bytes32(bytes(phrase));
        bytes32 result = variableExamples.convertStringToBytes(phrase);
        assertEq(result, expected);
    }

    function test_obterDataLength() public {
        variableExamples.armazenarDados(bytes("test data"));
        uint256 length = variableExamples.obterDataLength();
        assertEq(length, 9);
    }

    function test_insertMaxUint() public {
        uint8 testValue = 255;
        variableExamples.insertMaxUint(testValue);
        assertEq(variableExamples.limitInt(), testValue);
    }

    function test_insertNumber() public {
        uint256 testNumber = 123456789;
        variableExamples.insertNumber(testNumber);
        assertEq(variableExamples.number(), testNumber);
    }

    function test_sumNegative() public view {
        int256 testNumber = 10;
        int256 expected = testNumber + 1;
        int256 result = variableExamples.sumNegative(testNumber);
        assertEq(result, expected);
    }

    function test_sumNegative_WithNegativeInput() public view {
        int256 testNumber = -5;
        int256 expected = testNumber + 1;

        int256 result = variableExamples.sumNegative(testNumber);
        assertEq(result, expected);
    }
}
