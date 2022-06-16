pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

interface CarCollectible{
    struct Attr {
        string brand;
        string model;
        uint16 year;
        uint32 price;
        uint16 iot_account;
    }
    function check_ownership(uint256 tokenId) external view returns (address payable);
    function get_attributes(uint256 tokenId) external view returns(Attr memory attr);
}

interface APIConsumer{
    function requestVolumeData(address callBackContract, bytes4 selector, uint256 tokenID) external;
    function getMapping(bytes32 _requestId) external view returns(uint256 tokenID);
}

contract Insurance is ChainlinkClient{

    mapping(uint256 => Policy) public policy;
    mapping(uint256 => Claim) public claim;

    address validator;      //Address of a Insurance validator for whitelisitng

    struct Policy {
        string brand;
        string model;
        uint16 year;
        uint32 price;
        uint16 iot_account;
        uint256 purchase;
    }

    struct Claim {
        uint256 tokenID;
        uint256 claimSum;
        uint8 flag;             //0 = denied, 1 = onHold, 2 = payed
        uint256 weatherCode;
    }

    CarCollectible public cc_address;
    CarCollectible.Attr attr;

    APIConsumer public chainlink;

    constructor () public
    {
        cc_address = CarCollectible(0x3609c19b2975a7f198F77e1C656791C2CD37e039);        //--> Enter address of NFT Smart Contract after Deployment
        chainlink = APIConsumer(0x7578c5528Eb516F6Bc82Ed693225fddC8cE43f0e);            //--> Enter address of Chainlink Smart Contract after Deployment
        validator = 0xd0d6fAB7D2fec84271a10c0106FD177A98dc0356;                         //--> Enter address of validator account (e.g. in metaMask)
    }

    modifier onlyValidator() {
        require(msg.sender == validator, "User has no Validator access");
        _;
    }
    
    function get_metadata(uint256 tokenId) external view returns (CarCollectible.Attr memory attr)
    {
        return cc_address.get_attributes(tokenId);
    }

    function get_premium() external view returns (uint256) {
        return 50000000000000000;
    }

    function createClaim(uint256 tokenID, uint256 claimSum) public {
        require(policy[tokenID].purchase > 0,"There is no policy available for this car");
        address owner = cc_address.check_ownership(tokenID);
        require(msg.sender == owner,"Sorry, you are not the owner of this NFT");
        uint256 claimAmount = claimSum;
        claim[tokenID].tokenID = tokenID;
        claim[tokenID].claimSum = claimAmount;
        chainlink.requestVolumeData(address(this), this.APIFullFill.selector, tokenID);
    }

    function APIFullFill(bytes32 _requestId, uint256 _code) external {
        uint256 tokenID = chainlink.getMapping(_requestId);
        address payable receiver = cc_address.check_ownership(tokenID);
        claim[tokenID].weatherCode = _code;
        if(_code == 80100) {
            if(claim[tokenID].claimSum > 20000000000000000) {
                claim[tokenID].flag = 1;        //need Validator
            } else {
                claim[tokenID].flag = 2;        //Payout
                receiver.transfer(claim[tokenID].claimSum);
            }
        } else {
            claim[tokenID].flag = 0;            //no Hail occured
        }
    }

    function write_policy(uint256 _tokenID, string memory _brand, string memory _model, uint16 _year, uint32 _price, uint16 _iot) public payable {
        address owner = cc_address.check_ownership(_tokenID);
        require(msg.sender == owner,"Sorry, you are not the owner of this NFT");
        policy[_tokenID] = Policy(_brand,_model, _year, _price, _iot, block.timestamp);
    }

    function get_policy(uint256 tokenID) external view returns(Policy memory pol) {
        return policy[tokenID];
    }

    function getClaim(uint256 tokenID) external view returns(Claim memory clm) {
        return claim[tokenID];
    }

    function releaseClaim(uint256 tokenID) public onlyValidator {
        require(policy[tokenID].purchase > 0,"There is no policy available for this car");
        require(claim[tokenID].flag == 1, "Claim is not on hold");
        address payable receiver = cc_address.check_ownership(tokenID);
        receiver.transfer(claim[tokenID].claimSum);
    }
        
}