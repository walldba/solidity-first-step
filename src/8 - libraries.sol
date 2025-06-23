// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library StringUtils {
    function compareString(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

contract LibraryExample {
    using StringUtils for string;

    function checkProductName(
        string memory _productName
    ) external pure returns (bool) {
        return _productName.compareString("Xiaomi Redmi Note 10 Pro");
    }

    function checkProductName2(
        string memory _productName
    ) external pure returns (bool) {
        return
            StringUtils.compareString(_productName, "Xiaomi Redmi Note 10 Pro");
    }
}
