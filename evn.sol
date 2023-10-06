// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventContract {
    struct Event {
        address[] participants; // Store addresses participating in the event
        address winner;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => bool) public endedEvents;

    event EventEnded(uint256 indexed eventID, address indexed selectedAddress);

    function enrollForEvent(uint256 _eventID) public {
        require(!endedEvents[_eventID], "Event has already ended");
        events[_eventID].participants.push(msg.sender);
    }

    function endEvent(uint256 _eventID) public {
        require(!endedEvents[_eventID], "Event has already ended");
        require(events[_eventID].participants.length > 0, "No participants for the event");

        uint256 participantCount = events[_eventID].participants.length;
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, _eventID))) % participantCount;
        address selected = events[_eventID].participants[randomIndex];
        events[_eventID].winner = selected;
        endedEvents[_eventID] = true;
        emit EventEnded(_eventID, selected);
    }

    function getWinnerForEvent(uint256 _eventID) public view returns (uint256, address) {
        require(endedEvents[_eventID], "Event has not ended yet");
        return (_eventID, events[_eventID].winner);
    }

    function getAddressBalance(address _userAddress) public view returns (uint256) {
        return _userAddress.balance;
    }
}
