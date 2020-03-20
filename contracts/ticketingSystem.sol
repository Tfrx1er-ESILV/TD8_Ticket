pragma solidity ^0.5.12;

//We import contracts
import './artistList.sol';
import './venueList.sol';
import './concertList.sol';
import './ticketList.sol';

//This is the main contract
contract ticketingSystem is artistList, venueList, concertList,ticketList
{
    //The constructor, must be empty
    constructor () public{}
    //Creation of a concert
    function createConcert(uint _artistId, uint _venueId, uint _concertDate, uint _ticketPrice) public {
        concertProfil storage newConcert = concertsRegister[pointerConcert];
        newConcert.artistId =_artistId;
        newConcert.venueId = _venueId;
        newConcert.concertDate = _concertDate;
        newConcert.ticketPrice = _ticketPrice;
        newConcert.totalSoldTicket = 0;
        newConcert.totalMoneyCollected =0;
        //Set validation
        //We test if the sender is one of the actors
        concertsRegister[pointerConcert].validatedByArtist = (msg.sender == artistsRegister[_artistId].owner);
        concertsRegister[pointerConcert].validatedByVenue =(msg.sender == venuesRegister[_venueId].owner);
        
        concertsRegister[pointerConcert].happening = false;
        //We increment the pointer
        pointerConcert = pointerConcert+1;
    }
    //Validation of a concert
    function validateConcert(uint _concertId) public {
        //check out the artist and venue address
        address payable artist = artistsRegister[concertsRegister[_concertId].artistId].owner;
        address payable venue = venuesRegister[concertsRegister[_concertId].venueId].owner;
        //Not necessary requirement
        require(
            (msg.sender == artist || msg.sender == venue),
            "You are not allowed to validate anything"
        );
        if(msg.sender == artist){
            concertsRegister[_concertId].validatedByArtist = true;
        }
        if(msg.sender == venue){
            concertsRegister[_concertId].validatedByVenue = true;
        }
    }
    //Creation of a ticket
    function emitTicket(uint _concertId, address payable _ticketOwner) public {
        //check out the artist address
        address payable artist = artistsRegister[concertsRegister[_concertId].artistId].owner;
        require(
            (msg.sender == artist),
            "You are not allowed to emit a ticket"
        );
        //Now we can create a ticket
        ticket storage newTicket = ticketsRegister[pointerTicket];
        newTicket.concertId = _concertId;
        newTicket.owner = _ticketOwner;
        newTicket.isAvailable  = true;

        pointerTicket = pointerTicket +1;

        //We do not forget to add 1 to the ticket sold amount 
        artistsRegister[concertsRegister[_concertId].artistId].totalTicketsSold = artistsRegister[concertsRegister[_concertId].artistId].totalTicketsSold + 1;
        concertsRegister[_concertId].totalSoldTicket = concertsRegister[_concertId].totalSoldTicket+1;
    }
    //Use a ticket 
    function useTicket(uint _ticketId) public {
        //Do not understand what useTicket is suppose to do
        //But I know the requirement so :

        //1st you have to be the owner
        require(
            msg.sender == ticketsRegister[_ticketId].owner,
            "You are not the owner of the ticket"
        );

        //2nd you can't use it more than 24 hours before the event
        uint oneDay = 60*60*24;
        require(
            (now > concertsRegister[ticketsRegister[_ticketId].concertId].concertDate - oneDay ),
            "You can't use your ticket yet"
        );

        //3d you can't use it if the venue didn't validate it
        require(
            (concertsRegister[ticketsRegister[_ticketId].concertId].validatedByVenue),
            "The venue didn't validate it yet"
        );

    }
}


//Made by Théophile Freixa & Ronan Le Tilly