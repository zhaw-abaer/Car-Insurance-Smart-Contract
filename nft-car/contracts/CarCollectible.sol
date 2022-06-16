pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CarCollectible is ERC721 {

    uint256 public tokenCounter;

    mapping(uint256 => Attr) public attributes;

    struct Attr {
        string brand;
        string model;
        uint16 year;
        uint32 price;
        uint16 iot_account;
    }

    constructor () public ERC721("Cars", "CAR")
    {
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI, string memory brand, string memory model, uint16 year, uint32 price, uint16 iot_account) public returns (uint256)
    {
        uint256 newItemID = tokenCounter;
        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);
        attributes[newItemID] = Attr(brand, model, year, price, iot_account);
        tokenCounter = tokenCounter + 1;
        return newItemID;
    }

    function check_ownership(uint256 tokenId) external view returns (address payable)
    {
        address payable owner = address(uint160(ownerOf(tokenId)));
        return owner;
    }

    function get_attributes(uint256 tokenId) external view returns(Attr memory attr)
    {
        return attributes[tokenId];
    }

}
