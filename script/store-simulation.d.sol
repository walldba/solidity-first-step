// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Script.sol";
import "../src/10 - store-simulation.sol";

contract DeployStoreSimulation is Script {
    function run() public {
        vm.startBroadcast();

        StoreSimulation storeSimulation = new StoreSimulation();
        console.log("StoreSimulation deployed to:", address(storeSimulation));

        vm.stopBroadcast();
    }
}
