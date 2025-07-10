// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {LibraryExample, StringUtils} from "../src/8 - libraries.sol";

contract LibraryTest is Test {
    LibraryExample public libraryExample;

    function setUp() public {
        libraryExample = new LibraryExample();
    }

    function testCheckProductNameTrue() public {
        string memory productName = "Xiaomi Redmi Note 10 Pro";
        bool result = libraryExample.checkProductName(productName);
        assertTrue(result);
    }

    function testCheckProductNameFalse() public {
        string memory productName = "iPhone 14 Pro";
        bool result = libraryExample.checkProductName(productName);
        assertFalse(result);
    }

    function testCheckProductName2True() public {
        string memory productName = "Xiaomi Redmi Note 10 Pro";
        bool result = libraryExample.checkProductName2(productName);
        assertTrue(result);
    }

    function testCheckProductName2False() public {
        string memory productName = "iPhone 14 Pro";
        bool result = libraryExample.checkProductName2(productName);
        assertFalse(result);
    }
}
