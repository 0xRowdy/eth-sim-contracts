// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { EthSimSubscriber } from "../src/EthSimSubscriber.sol";

contract EthSimSubscriberTest is Test {
    EthSimSubscriber public ethSimSubscriber;
    Ownable public ownable;

    address owner = address(0x1);
    address nonOwner = address(0x2);

    function setUp() public {
        ethSimSubscriber = new EthSimSubscriber(owner);
    }

    function testAddSubscriberAsOwner() public {
        vm.startPrank(owner);

        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
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

        vm.stopPrank();
    }

    function testAddSubscriberAsNonOwner() public {
        vm.startPrank(nonOwner);

        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        // vm.expectRevert(abi.encodePacked("Ownable: caller is not the owner"));
        vm.expectRevert(Ownable.OwnableInvalidOwner.selector);
        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
        );

        vm.stopPrank();
    }

    function testAddSubscriber_AlreadyExists() public {
        vm.startPrank(owner);

        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
        );

        vm.expectRevert(abi.encodePacked("Subscriber already exists"));
        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
        );

        vm.stopPrank();
    }

    function testUpdateSubscriberAsOwner() public {
        vm.startPrank(owner);

        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
        );

        // Update subscriber details
        string memory newSubscriberName = "Jane Doe";
        string memory newDataPlan = "Limited";

        ethSimSubscriber.updateSubscriber(
            subscriberAddress, newSubscriberName, imsi, authKey, authOpc, serviceState, newDataPlan, activeApn
        );

        EthSimSubscriber.Subscriber memory updatedSubscriber = ethSimSubscriber.getSubscriber(subscriberAddress);

        assertEq(updatedSubscriber.subscriberName, newSubscriberName);
        assertEq(updatedSubscriber.dataPlan, newDataPlan);

        vm.stopPrank();
    }

    function testUpdateSubscriberAsNonOwner() public {
        vm.startPrank(owner);

        address subscriberAddress = address(0x123);
        string memory subscriberName = "John Doe";
        string memory imsi = "123456789012345";
        bytes32 authKey = keccak256(abi.encodePacked("authKey"));
        bytes32 authOpc = keccak256(abi.encodePacked("authOpc"));
        bool serviceState = true;
        string memory dataPlan = "Unlimited";
        string memory activeApn = "internet";

        ethSimSubscriber.addSubscriber(
            subscriberAddress, subscriberName, imsi, authKey, authOpc, serviceState, dataPlan, activeApn
        );

        vm.stopPrank();

        // Non-owner tries to update subscriber details
        vm.startPrank(nonOwner);

        string memory newSubscriberName = "Jane Doe";
        string memory newDataPlan = "Limited";

        vm.expectRevert(abi.encodePacked("Ownable: caller is not the owner"));
        ethSimSubscriber.updateSubscriber(
            subscriberAddress, newSubscriberName, imsi, authKey, authOpc, serviceState, newDataPlan, activeApn
        );

        vm.stopPrank();
    }

    function testGetSubscriber_NonExistent() public {
        address subscriberAddress = address(0x123);

        vm.expectRevert(abi.encodePacked("Subscriber does not exist"));
        ethSimSubscriber.getSubscriber(subscriberAddress);
    }
}
