// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OperatorsExample {
    uint256 public value;
    uint256 private minAgeToDrive = 18;

    function calculateAVG(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 avg = (a + b) / 2;
        return avg;
    }

    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function sum(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; //1014 gas costs
    }

    function sumUsingOpcode(
        uint256 a,
        uint256 b
    ) public pure returns (uint256 result) {
        assembly {
            result := add(a, b)
        }

        return result; //813 gas costs
    }

    function checkBoolean(bool a, bool b) public pure returns (bool) {
        return a == b;
    }

    function setValue(uint256 newValue) public returns (uint256) {
        if (newValue >= 10) {
            value = newValue;

            return value;
        } else {
            value = 0;
            return value;
        }
    }

    function verifyUserCanDrive(uint256 age) internal view {
        require(age >= minAgeToDrive, "You are not old enough to drive");
    }

    function emitDriveLicense(
        uint256 age,
        string memory name
    ) public view returns (string memory) {
        verifyUserCanDrive(age);

        return string(abi.encodePacked("Your drive is good, ", name));
    }
}
