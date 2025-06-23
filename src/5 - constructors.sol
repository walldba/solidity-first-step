// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract constructorExample {
    string public name;
    uint256 immutable age;
    address constant owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    constructor(string memory _name, uint256 _age) {
        name = _name;
        age = _age;
    }

    function setName(string memory _name) external {
        require(msg.sender == owner, "Only the owner can call this method");

        name = _name;
    }
}
