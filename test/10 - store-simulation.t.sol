// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {StoreSimulation} from "../src/10 - store-simulation.sol";

contract StoreSimulationTest is Test {
    StoreSimulation public storeSimulation;
    address testClient = address(0x123);
    address payable constant appleStore =
        payable(0x617F2E2fD72FD9D5503197092aC168c91465E7f2);

    function setUp() public {
        storeSimulation = new StoreSimulation();
        vm.deal(testClient, 10000 ether);
    }

    function testInitialProducts() public view {
        (
            uint256 id,
            string memory name,
            uint256 price,
            uint256 quantity,
            bool isAvailable
        ) = storeSimulation.products(0);
        assertEq(id, 0);
        assertEq(name, "Iphone 15");
        assertEq(price, 1000);
        assertEq(quantity, 5);
        assertTrue(isAvailable);

        (id, name, price, quantity, isAvailable) = storeSimulation.products(1);
        assertEq(id, 1);
        assertEq(name, "MacBook");
        assertEq(price, 2000);
        assertEq(quantity, 10);
        assertTrue(isAvailable);

        (id, name, price, quantity, isAvailable) = storeSimulation.products(2);
        assertEq(id, 2);
        assertEq(name, "AppleWatch");
        assertEq(price, 1500);
        assertEq(quantity, 15);
        assertTrue(isAvailable);
    }

    function testLogin() public {
        vm.startPrank(testClient);

        bool result = storeSimulation.login(20);
        assertTrue(result);

        (
            uint256 paidAmount,
            uint256 age,
            StoreSimulation.Status status,
            bool approved,
            uint256 productId
        ) = storeSimulation.clients(testClient);
        assertEq(paidAmount, 0);
        assertEq(age, 20);
        assertEq(uint(status), uint(StoreSimulation.Status.LOGGED));
        assertTrue(approved);
        assertEq(productId, 0);

        vm.stopPrank();
    }

    function test_Revert_When_LoginWithUnderageClient() public {
        vm.startPrank(testClient);

        vm.expectRevert();
        storeSimulation.login(17);

        vm.stopPrank();
    }

    function testAddProduct() public {
        string memory productName = "AirPods";
        uint256 price = 500;
        uint256 quantity = 20;

        storeSimulation.addProduct(productName, price, quantity);

        (
            uint256 id,
            string memory name,
            uint256 productPrice,
            uint256 productQuantity,
            bool isAvailable
        ) = storeSimulation.products(3);

        assertEq(id, 4);
        assertEq(name, productName);
        assertEq(productPrice, price);
        assertEq(productQuantity, quantity);
        assertTrue(isAvailable);
    }

    function test_Revert_When_AddProductNotOwner() public {
        vm.startPrank(testClient);

        vm.expectRevert("Ownable: caller is not the owner");
        storeSimulation.addProduct("AirPods", 500, 20);

        vm.stopPrank();
    }

    function testListProductsAvailable() public view {
        StoreSimulation.Product[] memory products = storeSimulation
            .listProductsAvailable();

        assertEq(products.length, 3);
        assertEq(products[0].id, 0);
        assertEq(products[0].name, "Iphone 15");
        assertEq(products[1].id, 1);
        assertEq(products[1].name, "MacBook");
        assertEq(products[2].id, 2);
        assertEq(products[2].name, "AppleWatch");
    }

    function testExecutePurchase() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;

        vm.startPrank(testClient);
        storeSimulation.login(20);

        storeSimulation.executePurchase{value: productPrice}(productId);

        (
            uint256 paidAmount,
            ,
            StoreSimulation.Status status,
            ,
            uint256 clientProductId
        ) = storeSimulation.clients(testClient);
        assertEq(paidAmount, productPrice);
        assertEq(uint(status), uint(StoreSimulation.Status.PURCHASED));
        assertEq(clientProductId, productId);

        vm.stopPrank();
    }

    function test_Revert_When_ExecutePurchaseWithWrongPrice() public {
        uint256 productId = 0;
        uint256 wrongPrice = 900;

        vm.startPrank(testClient);
        storeSimulation.login(20);

        vm.expectRevert("Value must match product price exactly");
        storeSimulation.executePurchase{value: wrongPrice}(productId);

        vm.stopPrank();
    }

    function test_Revert_When_ExecutePurchaseWithoutLogin() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;

        vm.startPrank(testClient);

        vm.expectRevert("Not authorized");
        storeSimulation.executePurchase{value: productPrice}(productId);

        vm.stopPrank();
    }

    function testConfirmReceiveTrue() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;
        uint256 initialQuantity = 5;

        uint256 initialAppleStoreBalance = address(appleStore).balance;

        vm.startPrank(testClient);
        storeSimulation.login(20);
        storeSimulation.executePurchase{value: productPrice}(productId);

        storeSimulation.confirmReceive(true);

        (
            uint256 paidAmount,
            ,
            StoreSimulation.Status status,
            ,

        ) = storeSimulation.clients(testClient);
        assertEq(paidAmount, 0);
        assertEq(uint(status), uint(StoreSimulation.Status.RECEIVED));

        (, , , uint256 newQuantity, ) = storeSimulation.products(productId);
        assertEq(newQuantity, initialQuantity - 1);

        assertEq(
            address(appleStore).balance,
            initialAppleStoreBalance + productPrice
        );

        vm.stopPrank();
    }

    function testConfirmReceiveFalse() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;

        vm.startPrank(testClient);
        uint256 initialClientBalance = address(testClient).balance;
        storeSimulation.login(20);
        storeSimulation.executePurchase{value: productPrice}(productId);

        uint256 balanceAfterPurchase = address(testClient).balance;
        assertEq(balanceAfterPurchase, initialClientBalance - productPrice);

        storeSimulation.confirmReceive(false);

        uint256 finalBalance = address(testClient).balance;
        assertEq(finalBalance, balanceAfterPurchase + productPrice);
        assertEq(finalBalance, initialClientBalance);

        vm.stopPrank();
    }

    function testProductUnavailableAfterQuantityZero() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;

        vm.startPrank(testClient);
        storeSimulation.login(20);

        for (uint i = 0; i < 5; i++) {
            storeSimulation.executePurchase{value: productPrice}(productId);
            storeSimulation.confirmReceive(true);
        }

        (, , , uint256 quantity, bool isAvailable) = storeSimulation.products(
            productId
        );
        assertEq(quantity, 0);
        assertFalse(isAvailable);

        vm.stopPrank();
    }

    function test_Revert_When_PurchaseUnavailableProduct() public {
        uint256 productId = 0;
        uint256 productPrice = 1000;

        vm.startPrank(testClient);
        storeSimulation.login(20);

        for (uint i = 0; i < 5; i++) {
            storeSimulation.executePurchase{value: productPrice}(productId);
            storeSimulation.confirmReceive(true);
        }

        vm.expectRevert("Not available product");
        storeSimulation.executePurchase{value: productPrice}(productId);

        vm.stopPrank();
    }
}
