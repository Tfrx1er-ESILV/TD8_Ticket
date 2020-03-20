pragma solidity ^0.5.12;
//This contract contain all the artist containers
contract artistList
{
    struct artistProfil {
        //Artist parameters
        bytes32 name;
        uint artistCategory;
        uint totalTicketsSold;
        //Creator
        //This will allow us to prevent someone from changing another person's artist
        address payable owner; 
    }
    //Create the pointer
    uint pointerArtist = 1;
    //List of all artist profiles
    mapping(uint => artistProfil) public artistsRegister;
    //Create an artist
    function createArtist(bytes32 _name, uint _type) public {
        artistProfil storage newArtist = artistsRegister[pointerArtist];
        newArtist.name = _name;
        newArtist.artistCategory = _type;
        newArtist.totalTicketsSold = 0;
        newArtist.owner = msg.sender;
        //We increment the pointer
        pointerArtist= pointerArtist +1;
    }
    //Modify an artist
    function modifyArtist(uint _artistId, bytes32 _name, uint _artistCategory, address payable _newOwner) public {
        //Just allow the owner
        require(
            msg.sender == artistsRegister[_artistId].owner,
            "You are not allowed to modify the artist"
        );
        //Apply the modifications
        artistsRegister[_artistId].name = _name;
        artistsRegister[_artistId].artistCategory = _artistCategory;
        artistsRegister[_artistId].owner = _newOwner;
    }
}
//This contract contain all the venue containers
contract venueList
{
    struct venueProfil {
        //venue parameters
        bytes32 name;
        uint capacity;
        uint standardComission;
        //Creator
        //This will allow us to prevent someone from changing another person's venue
        address payable owner; 
    }
    //Create the pointer
    uint pointerVenue = 1;
    //List of all artist profiles
    mapping(uint => venueProfil) public venuesRegister;
    //Create a venue
    function createVenue(bytes32 _name, uint _capacity, uint _standardComission) public{
        venueProfil storage newVenue = venuesRegister[pointerVenue];
        newVenue.name =_name;
        newVenue.capacity =_capacity;
        newVenue.standardComission =_standardComission;
        newVenue.owner  = msg.sender;
        //We increment the pointer
        pointerVenue= pointerVenue +1;
    }
    //Modify a Venue
    function modifyVenue(uint _venueId, bytes32 _name, uint _capacity, uint _standardComission, address payable _newOwner) public {
        //Just allow the owner
        require(
            msg.sender == venuesRegister[_venueId].owner,
            "You are not allowed to modify the venue"
        );
        //Apply the modifications
        venuesRegister[_venueId].name = _name;
        venuesRegister[_venueId].capacity = _capacity;
        venuesRegister[_venueId].standardComission = _standardComission;
        venuesRegister[_venueId].owner = _newOwner;
    }
}
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
//This contract contain all the tickets containers
contract ticketList{
    struct ticket{
        //ticket parameters
        uint concertId;
        address payable owner;

        bool isAvailable;

    }
    //Create the pointer
    uint pointerTicket = 1;
    //List of all artist profiles
    mapping(uint => ticket) public ticketsRegister;
}
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