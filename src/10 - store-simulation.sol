// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract StoreSimulation {
    enum Status {
        PENDING,
        LOGGED,
        PURCHASE,
        RECEIVE
    }

    Status public status;
    uint256 minAge = 18;
    mapping(address => bool) public approved;
    mapping(address => uint256) balance;

    address payable constant appleStore =
        payable(0x617F2E2fD72FD9D5503197092aC168c91465E7f2);

    mapping(string => uint256) private products;

    constructor() {
        products["Iphone 15"] = 5;
        products["MacBook"] = 10;
        products["AppleWatch"] = 15;
    }

    function get() external view returns (Status) {
        return status;
    }

    function login(uint256 _idade) external returns (bool) {
        if (_idade < minAge) {
            string memory message = string(
                abi.encodePacked("Your age must be greater than", minAge)
            );

            revert(message);
        } else {
            status = Status.LOGGED;
            approved[msg.sender] = true;

            return true;
        }
    }

    function executePurchase(string memory _productName) external payable {
        require(approved[msg.sender], "Not authorized");
        if (products[_productName] == 0) revert("Not available product");

        require(
            msg.value >= products[_productName],
            "Invalid price for this product"
        );

        balance[msg.sender] += msg.value;
        status = Status.PURCHASE;
    }

    function confirmReceive(bool _receive) external {
        require(approved[msg.sender], "Not authorized");

        if (_receive == true) {
            payable(appleStore).transfer(address(this).balance);
            status = Status.RECEIVE;
        } else {
            payable(msg.sender).transfer(balance[msg.sender]);
        }
    }
}
