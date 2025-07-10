// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {StrucExample} from "../src/9 - struct.sol";

contract StructTest is Test {
    StrucExample public structExample;
    address testUser = address(0x123);

    function setUp() public {
        structExample = new StrucExample();
    }

    function testCreateUser() public {
        string memory name = "John Doe";
        uint256 age = 30;

        vm.prank(testUser);
        StrucExample.User memory user = structExample.createUser(name, age);

        assertEq(user.name, name);
        assertEq(user.age, age);
        assertEq(user.account, testUser);
        assertTrue(user.isActive);
        assertEq(uint(user.status), 0);
    }

    function testGetUsers() public {
        string memory name1 = "John Doe";
        uint256 age1 = 30;
        string memory name2 = "Jane Smith";
        uint256 age2 = 25;

        vm.prank(testUser);
        structExample.createUser(name1, age1);

        vm.prank(address(0x456));
        structExample.createUser(name2, age2);

        StrucExample.User[] memory users = structExample.getUsers();

        assertEq(users.length, 2);
        assertEq(users[0].name, name1);
        assertEq(users[0].age, age1);
        assertEq(users[0].account, testUser);

        assertEq(users[1].name, name2);
        assertEq(users[1].age, age2);
        assertEq(users[1].account, address(0x456));
    }

    function testCreateUserWithDifferentAddresses() public {
        string memory name1 = "John Doe";
        uint256 age1 = 30;

        address user1 = address(0x111);
        address user2 = address(0x222);

        vm.prank(user1);
        StrucExample.User memory createdUser1 = structExample.createUser(
            name1,
            age1
        );

        vm.prank(user2);
        StrucExample.User memory createdUser2 = structExample.createUser(
            name1,
            age1
        );

        assertEq(createdUser1.account, user1);
        assertEq(createdUser2.account, user2);
    }
}
