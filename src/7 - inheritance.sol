// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract BaseExample {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }

    function makeSound() external pure virtual returns (string memory) {
        return "Coin";
    }
}

contract InheritanceExample is BaseExample {
    constructor(string memory _name) BaseExample(_name) {}

    function makeSound() external pure override returns (string memory) {
        return "Buy Coin";
    }
}
