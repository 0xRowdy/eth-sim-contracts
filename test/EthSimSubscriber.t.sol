/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { EthSimSubscriber } from "../src/EthSimSubscriber.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract EthSimSubscriberTest is Test {
    EthSimSubscriber public ethSimSubscriber;

    function setUp() public {
        ethSimSubscriber = new EthSimSubscriber();
    }

    function testAddSubscriber() public {
        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress,
            subscriberName,
            imsi,
            authKey,
            authOpc,
            serviceState,
            dataPlan,
            activeApn
        );

        EthSimSubscriber.Subscriber memory subscriber = ethSimSubscriber.getSubscriber(subscriberAddress);

        assertEq(subscriber.subscriberAddress, subscriberAddress);
        assertEq(subscriber.subscriberName, subscriberName);
        assertEq(subscriber.imsi, imsi);
        assertEq(subscriber.authKey, authKey);
        assertEq(subscriber.authOpc, authOpc);
        assertEq(subscriber.serviceState, serviceState);
        assertEq(subscriber.dataPlan, dataPlan);
        assertEq(subscriber.activeApn, activeApn);
    }

    function testAddSubscriber_AlreadyExists() public {
        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress,
            subscriberName,
            imsi,
            authKey,
            authOpc,
            serviceState,
            dataPlan,
            activeApn
        );

        vm.expectRevert("Subscriber already exists");
        ethSimSubscriber.addSubscriber(
            subscriberAddress,
            subscriberName,
            imsi,
            authKey,
            authOpc,
            serviceState,
            dataPlan,
            activeApn
        );
    }

    function testGetSubscriber_NonExistent() public {
        address subscriberAddress = address(0x123);

        vm.expectRevert("Subscriber does not exist");
        ethSimSubscriber.getSubscriber(subscriberAddress);
    }
}
