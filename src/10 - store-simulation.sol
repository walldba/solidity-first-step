// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract StoreSimulation {
    enum Status {
        PENDING,
        LOGGED,
        PURCHASED,
        RECEIVED
    }

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        uint256 quantity;
        bool isAvailable;
    }

    struct Client {
        uint256 paidAmount;
        uint256 age;
        Status status;
        bool approved;
        uint256 productId;
    }

    uint256 minAge = 18;

    address payable constant appleStore =
        payable(0x617F2E2fD72FD9D5503197092aC168c91465E7f2);

    Product[] public products;
    mapping(address => Client) public clients;

    event PurchaseExecuted(
        address indexed client,
        uint256 productId,
        uint256 price
    );

    event ReceiveConfirmed(
        address indexed client,
        uint256 productId,
        bool received
    );

    constructor() {
        products.push(
            Product({
                id: 0,
                name: "Iphone 15",
                price: 1000,
                quantity: 5,
                isAvailable: true
            })
        );
        products.push(
            Product({
                id: 1,
                name: "MacBook",
                price: 2000,
                quantity: 10,
                isAvailable: true
            })
        );
        products.push(
            Product({
                id: 2,
                name: "AppleWatch",
                price: 1500,
                quantity: 15,
                isAvailable: true
            })
        );
    }

    function getClientInformation() external view returns (Client memory) {
        return clients[msg.sender];
    }

    function login(uint256 _age) external returns (bool) {
        if (_age < minAge) {
            string memory message = string(
                abi.encodePacked("Your age must be greater than", minAge)
            );

            revert(message);
        } else {
            clients[msg.sender].status = Status.LOGGED;
            clients[msg.sender].approved = true;
            clients[msg.sender].age = _age;
            return true;
        }
    }

    function addProduct(
        string memory _name,
        uint256 _price,
        uint256 _quantity
    ) external {
        products.push(
            Product({
                id: products.length + 1,
                name: _name,
                price: _price,
                quantity: _quantity,
                isAvailable: true
            })
        );
    }

    function listProductsAvailable() external view returns (Product[] memory) {
        Product[] memory availableProducts = new Product[](products.length);

        uint256 availableCount = 0;
        for (uint256 i = 0; i < products.length; i++) {
            if (products[i].isAvailable == true) {
                availableProducts[availableCount] = products[i];
                availableCount++;
            }
        }

        return availableProducts;
    }

    function executePurchase(uint256 _productId) external payable {
        require(clients[msg.sender].approved, "Not authorized");
        require(
            msg.value == products[_productId].price,
            "Value must match product price exactly"
        );

        if (products[_productId].isAvailable == false)
            revert("Not available product");

        clients[msg.sender].paidAmount = msg.value;
        clients[msg.sender].status = Status.PURCHASED;
        clients[msg.sender].productId = _productId;

        emit PurchaseExecuted(msg.sender, _productId, msg.value);
    }

    function confirmReceive(bool _receive) external {
        require(clients[msg.sender].approved, "Not authorized");

        if (_receive == true) {
            payable(appleStore).transfer(clients[msg.sender].paidAmount);
            clients[msg.sender].status = Status.RECEIVED;
            clients[msg.sender].paidAmount = 0;
            products[clients[msg.sender].productId].quantity -= 1;

            if (products[clients[msg.sender].productId].quantity == 0) {
                products[clients[msg.sender].productId].isAvailable = false;
            }

            emit ReceiveConfirmed(
                msg.sender,
                clients[msg.sender].productId,
                true
            );
        } else {
            payable(msg.sender).transfer(clients[msg.sender].paidAmount);
        }
    }
}
