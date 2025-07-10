// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {arrayExamples} from "../src/3 - arrays.sol";

contract ArrayTest is Test {
    arrayExamples public arrayExample;

    function setUp() public {
        arrayExample = new arrayExamples();
    }

    function testSetProduct() public {
        string memory product = "iPhone";
        arrayExample.setProduct(product);
        assertEq(arrayExample.products(0), product);
    }

    function testGetProducts() public {
        string memory product1 = "iPhone";
        string memory product2 = "MacBook";

        arrayExample.setProduct(product1);
        arrayExample.setProduct(product2);

        string[] memory products = arrayExample.getProducts();

        assertEq(products.length, 2);
        assertEq(products[0], product1);
        assertEq(products[1], product2);
    }

    function testGetProductsLength() public {
        string memory product1 = "iPhone";
        string memory product2 = "MacBook";

        arrayExample.setProduct(product1);
        arrayExample.setProduct(product2);

        uint256 length = arrayExample.getProductsLength();
        assertEq(length, 2);
    }

    function testClearProducts() public {
        string memory product1 = "iPhone";
        string memory product2 = "MacBook";

        arrayExample.setProduct(product1);
        arrayExample.setProduct(product2);

        arrayExample.clearProducts();

        uint256 length = arrayExample.getProductsLength();
        assertEq(length, 0);
    }

    function testDeleteProductById() public {
        string memory product1 = "iPhone";
        string memory product2 = "MacBook";

        arrayExample.setProduct(product1);
        arrayExample.setProduct(product2);

        arrayExample.deleteProductById(0);

        string[] memory products = arrayExample.getProducts();

        assertEq(products[0], "");
        assertEq(products[1], product2);
        assertEq(products.length, 2);
    }

    function test_Revert_When_DeleteProductByIdWithInvalidIndex() public {
        string memory product1 = "iPhone";
        arrayExample.setProduct(product1);

        vm.expectRevert("Invalid index");
        arrayExample.deleteProductById(5);
    }
}
