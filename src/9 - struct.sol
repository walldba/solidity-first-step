// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StrucExample {
    enum Status {
        PENDING,
        LOGGED,
        PURCHASE,
        RECEIVE
    }

    struct User {
        string name;
        uint256 age;
        address account;
        bool isActive;
        Status status;
    }

    User[] users;

    function createUser(
        string memory _name,
        uint256 _age
    ) external returns (User memory) {
        User memory user = User({
            name: _name,
            age: _age,
            account: msg.sender,
            isActive: true,
            status: Status.PENDING
        });

        users.push(user);

        return user;
    }

    function getUsers() external view returns (User[] memory) {
        return users;
    }
}
