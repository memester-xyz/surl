// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Surl} from "src/Surl.sol";

contract SurlTest is Test {
    using Surl for *;

    function setUp() public {}

    function testGet() public {
        (uint256 status, bytes memory data) = "https://jsonplaceholder.typicode.com/todos/1".get();

        assertEq(status, 200);
        assertEq(string(data), '{  "userId": 1,  "id": 1,  "title": "delectus aut autem",  "completed": false}');
    }
}
