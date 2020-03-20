pragma solidity ^0.5.12;

//This contract contain all the artist containers
contract artistList
{
    struct artistProfil {
        //Artist parameters
        bytes32 name;
        uint artistCategory;
        uint totalTicketSold;
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
        newArtist.totalTicketSold = 0;
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