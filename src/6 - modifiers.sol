// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Modifier are like decorators
contract ModifierExamples {
    address public owner;
    uint256 x = 10;
    bool public locked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Invalid Owner");

        //this undescore is require, is like next() on JS;
        _;

        //If want to do something after the function...
    }

    modifier validAddress(address _address) {
        require(_address != address(0), "Invalid address!");

        _;
    }

    //Modifier to block reentrant atacks
    modifier noReentrant() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function changeOwner(
        address _newOwner
    ) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }
}
