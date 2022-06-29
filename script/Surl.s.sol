// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Surl} from "src/Surl.sol";

contract SurlScript is Script {
    using Surl for *;

    function setUp() public {}

    function run() public {
        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] = "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==";
        // running local flask script which just returns request headers as json
        (uint256 status, bytes memory data) = "http://localhost:5001".get(headers);

        console.log("status", status);
        console.log("data", string(data));
    }
    
}