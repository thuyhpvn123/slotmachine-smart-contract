// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SlotMachine} from "../src/slot.sol";

contract SlotMachineTest is Test {
    SlotMachine public SLOT;
    address public Deployer = address(0x1);
    address public player1 = address(0x2);
    constructor() public {
        vm.startPrank(Deployer);
        vm.deal(Deployer, 5 ether);
        SLOT = new SlotMachine();
        SLOT.deposit{value:1 ether}();
        vm.stopPrank();
    }

    function test_spin() public {
        vm.startPrank(Deployer);
        vm.deal(player1,  5000);
        SLOT.spin{value: 1000}(2);
        vm.stopPrank();
    }

}
