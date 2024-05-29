// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25 <0.9.0;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract EthSimSubscriber is Ownable {
    struct Subscriber {
        address subscriberAddress;
        string subscriberName;
        string imsi;
        bytes32 authKey; // Stored as hex
        bytes32 authOpc; // Stored as hex
        bool serviceState; // True if active, false if inactive
        string dataPlan;
        string activeApn;
    }

    mapping(address => Subscriber) private subscribers;

    event SubscriberAdded(address indexed subscriberAddress, string subscriberName);
    event SubscriberUpdated(address indexed subscriberAddress, string subscriberName);

    constructor(address initialOwner) Ownable(initialOwner) { }

    function addSubscriber(
        address _subscriberAddress,
        string memory _subscriberName,
        string memory _imsi,
        bytes32 _authKey,
        bytes32 _authOpc,
        bool _serviceState,
        string memory _dataPlan,
        string memory _activeApn
    )
        public
        onlyOwner
    {
        require(subscribers[_subscriberAddress].subscriberAddress == address(0), "Subscriber already exists");

        subscribers[_subscriberAddress] = Subscriber({
            subscriberAddress: _subscriberAddress,
            subscriberName: _subscriberName,
            imsi: _imsi,
            authKey: _authKey,
            authOpc: _authOpc,
            serviceState: _serviceState,
            dataPlan: _dataPlan,
            activeApn: _activeApn
        });

        emit SubscriberAdded(_subscriberAddress, _subscriberName);
    }

    function updateSubscriber(
        address _subscriberAddress,
        string memory _subscriberName,
        string memory _imsi,
        bytes32 _authKey,
        bytes32 _authOpc,
        bool _serviceState,
        string memory _dataPlan,
        string memory _activeApn
    )
        public
        onlyOwner
    {
        require(subscribers[_subscriberAddress].subscriberAddress != address(0), "Subscriber does not exist");

        subscribers[_subscriberAddress] = Subscriber({
            subscriberAddress: _subscriberAddress,
            subscriberName: _subscriberName,
            imsi: _imsi,
            authKey: _authKey,
            authOpc: _authOpc,
            serviceState: _serviceState,
            dataPlan: _dataPlan,
            activeApn: _activeApn
        });

        emit SubscriberUpdated(_subscriberAddress, _subscriberName);
    }

    function getSubscriber(address _subscriberAddress) public view returns (Subscriber memory) {
        require(subscribers[_subscriberAddress].subscriberAddress != address(0), "Subscriber does not exist");

        return subscribers[_subscriberAddress];
    }
}
