pragma solidity ^0.5.12;

//This contract contain all the concert containers
contract concertList{   
    struct concertProfil{
        //concert parameters
        uint artistId;
        uint venueId;
        uint concertDate;
        uint ticketPrice;
        uint totalSoldTicket;
        uint totalMoneyCollected;

        //both validation
        bool validatedByArtist;
        bool validatedByVenue;

        bool happening;
    }
    //Create the pointer
    uint pointerConcert = 1;
    //List of all artist profiles
    mapping(uint => concertProfil) public concertsRegister;
}