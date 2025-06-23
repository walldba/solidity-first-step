// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MappingExamples {
    mapping(string => uint256) public products;

    function addProduct(string memory _name, uint256 _id) external {
        products[_name] = _id;
    }
}
