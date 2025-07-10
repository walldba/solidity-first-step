// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {MappingExamples} from "../src/4 - mappings.sol";

contract MappingTest is Test {
    MappingExamples public mappingExample;

    function setUp() public {
        mappingExample = new MappingExamples();
    }

    function testAddProduct() public {
        string memory productName = "iPhone";
        uint256 productId = 1;
        
        mappingExample.addProduct(productName, productId);
        
        assertEq(mappingExample.products(productName), productId);
    }
    
    function testUpdateProduct() public {
        string memory productName = "iPhone";
        uint256 initialProductId = 1;
        uint256 updatedProductId = 2;
        
        mappingExample.addProduct(productName, initialProductId);
        assertEq(mappingExample.products(productName), initialProductId);
        
        // Update the same product with a new ID
        mappingExample.addProduct(productName, updatedProductId);
        assertEq(mappingExample.products(productName), updatedProductId);
    }
    
    function testMultipleProducts() public {
        string memory product1 = "iPhone";
        string memory product2 = "MacBook";
        uint256 id1 = 1;
        uint256 id2 = 2;
        
        mappingExample.addProduct(product1, id1);
        mappingExample.addProduct(product2, id2);
        
        assertEq(mappingExample.products(product1), id1);
        assertEq(mappingExample.products(product2), id2);
    }
}
