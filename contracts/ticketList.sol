pragma solidity ^0.5.12;

//This contract contain all the tickets containers
contract ticketList{
    struct ticket{
        //ticket parameters
        uint concertId;
        address payable owner;

        bool isAvailable;

        bool isAvailableForSale;
        uint amountPaid;

    }
    //Create the pointer
    uint pointerTicket = 1;
    //List of all artist profiles
    mapping(uint => ticket) public ticketsRegister;
}