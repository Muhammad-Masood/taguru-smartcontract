// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {TAGuru} from "../src/TaGuru.sol";

contract TAGuruDeployScript is Script {
    
    function run() external returns(TAGuru) {
        vm.startBroadcast();
        TAGuru taGuru = new TAGuru();
        vm.stopBroadcast();
        console.log("Deployed TAGuru.sol on: ", address(taGuru), "owner: ", taGuru.owner());
        return taGuru;
    }
}
