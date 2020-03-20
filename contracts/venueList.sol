pragma solidity ^0.5.12;

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