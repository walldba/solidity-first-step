// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract arrayExamples {
    string[] public products;

    function setProduct(string memory product) external {
        products.push(product);
    }

    function getProducts() external view returns (string[] memory) {
        return products;
    }

    function getProductsLength() external view returns (uint256) {
        return products.length;
    }

    function clearProducts() external {
        delete products;
    }

    function deleteProductById(uint256 index) external {
        require(index < products.length, "Invalid index");

        delete products[index];
    }
}
