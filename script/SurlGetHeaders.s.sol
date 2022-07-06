// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Surl} from "src/Surl.sol";

contract SurlGetHeadersScript is Script {
    using Surl for *;

    function setUp() public {}

    function run() public {
        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] = "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==";
        (uint256 status, bytes memory data) = "https://httpbin.org/headers".get(headers);

        console.log("status", status);
        console.log("data", string(data));
    }
}
