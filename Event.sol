// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Smart contract for organizing events and managing tickets
contract Event_Organization{
    // Structure defining an event
    struct Event{
     address organizer;
     string show_name;
     uint date;
     uint price;
     uint ticketcount;
     uint ticketremain;
    }

    // Mapping to store events by their unique IDs
    mapping (uint=>Event) public events;
    // Mapping to store ticket ownership
    mapping (address =>mapping(uint=>uint)) public tickets;
    // Counter for generating unique IDs for events
    uint public nextId;

    // Function to create a new event
    function createEvent(string memory eventname,uint date,uint price,uint ticketcount) external{
            // Ensuring event date is in the future
            require(date>block.timestamp,"only future event date allowed");
            // Ensuring event has at least one ticket
            require(ticketcount>0,"event must have more than 0 tickets");
            // Storing the event with its details
            events[nextId]= Event(msg.sender,eventname,date,price,ticketcount,ticketcount);
            // Incrementing the ID for the next event
            nextId++;
    }

    // Function to buy tickets for an event
    function buyTicket(uint id,uint quantity) external payable{
        // Checking if the event exists
        require(events[id].date!=0,"This event does not exist");
        // Checking if the event date is in the future
        require(events[id].date>block.timestamp,"This event has already occurred");
        // Retrieving the event details
        Event storage _event = events[id];
        // Checking if the sent ether matches the total ticket price
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        // Decreasing the remaining ticket count
        _event.ticketremain-=quantity;
        // Updating ticket ownership
        tickets[msg.sender][id]+=quantity;
    }

    // Function to transfer tickets to another address
    function transfer(uint id,uint quantity,address to) external {
         // Checking if the event exists
         require(events[id].date!=0,"This event does not exist");
         // Checking if the event date is in the future
         require(events[id].date>block.timestamp,"This event has already occurred");
         // Checking if the sender owns enough tickets to transfer
         require(tickets[msg.sender][id]>=quantity,"you transact more tickets than you have");
         // Updating ticket ownership for sender and receiver
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
