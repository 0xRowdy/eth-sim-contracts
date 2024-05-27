// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

contract EthSimSubscriber {
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

    function addSubscriber(
        address _subscriberAddress,
        string memory _subscriberName,
        string memory _imsi,
        bytes32 _authKey,
        bytes32 _authOpc,
        bool _serviceState,
        string memory _dataPlan,
        string memory _activeApn
    ) public {
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

    function getSubscriber(address _subscriberAddress) public view returns (Subscriber memory) {
        require(subscribers[_subscriberAddress].subscriberAddress != address(0), "Subscriber does not exist");

        return subscribers[_subscriberAddress];
    }
}
