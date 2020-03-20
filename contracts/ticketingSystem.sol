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
//This is the main contract
contract ticketingSystem is artistList, venueList
{
    constructor () public{}
}


//Made by Théophile Freixa & Ronan Le Tilly