// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address public oracle;
    bytes32 public jobId;
    uint256 public fee;

    event DataFullfilled(uint256 code);

    mapping (bytes32 => uint) public requestMapping;
    
    constructor() {
        
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);      // Kovan Test Netzwerk Adresse
        
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;                // API Oracle
        jobId = "d5270d1c311941d0b08bead21fea7747";                         // Job für uint256 Datentyp
        fee = 100000000000000000;                                           // 1 Link Gebühr
    }
    
    function requestVolumeData(address callBackContract, bytes4 selector, uint256 tokenID) external
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, callBackContract, selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://api.weatherbit.io/v2.0/current?lat=35.7796&lon=-78.6382&key=Weatherbit_API_KEY");
        
        request.add("path", "data,0,weather,code");
        
        // Sends the request
        bytes32 requestId = sendChainlinkRequestTo(oracle, request, fee);
        requestMapping[requestId] = tokenID;
    }

    function getMapping(bytes32 _requestId) external view returns(uint256 tokenID)
    {
        return requestMapping[_requestId];
    } 
}
