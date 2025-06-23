// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract VariableExamples {
    uint8 public testLimit;
    int256 public negative = -1;
    uint256 public number;
    int256 public negativeNumber;

    bool public permition;
    address public registredAddress;
    string public name;
    bytes public meusBytes;

    function changePermition(bool _permition) external {
        permition = _permition;
    }

    function registerAdress(address _address) external {
        registredAddress = _address;
    }

    function registerMyAdress(string memory _name) external {
        registredAddress = msg.sender;
        name = _name;
    }

    function armazenarDados(bytes memory _data) public {
        meusBytes = _data;
    }

    function convertStringToBytes(
        string memory _phrase
    ) external pure returns (bytes32) {
        bytes32 bytePhrase = bytes32(bytes(_phrase));

        return bytePhrase;
    }

    function obterDataLength() public view returns (uint256) {
        return meusBytes.length;
    }

    function insertMaxUint(uint8 _number) external {
        testLimit = _number;
    }

    function insertNumber(uint256 _number) external {
        number = _number;
    }

    function testNegative(int256 _number) external view returns (int256) {
        int256 negativeNum = _number;

        int256 negativeSum = negativeNum - negative;

        return (negativeSum);
    }
}
