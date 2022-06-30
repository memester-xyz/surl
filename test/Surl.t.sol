// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Surl} from "src/Surl.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract SurlTest is Test {
    using Surl for *;
    using strings for *;

    function setUp() public {}

    function testGet() public {
        (uint256 status, bytes memory data) = "https://jsonplaceholder.typicode.com/todos/1".get();

        assertEq(status, 200);
        assertEq(string(data), '{  "userId": 1,  "id": 1,  "title": "delectus aut autem",  "completed": false}');
    }

    function testGetOptions() public {
        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] = "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==";
        (uint256 status, bytes memory data) = "https://httpbin.org/headers".get(headers);

        assertEq(status, 200);

        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("QWxhZGRpbjpvcGVuIHNlc2FtZQ==").toSlice()));
        assertTrue(responseText.contains(("application/json").toSlice()));
    }

    function testPostFormData() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/x-www-form-urlencoded";
        (uint256 status, bytes memory data) = "https://httpbin.org/post".post(
            headers,
            "formfield=myemail@ethereum.org"
        );

        assertEq(status, 200);

        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("formfield").toSlice()));
        assertTrue(responseText.contains(("myemail@ethereum.org").toSlice()));
    }

    function testPostJson() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        (uint256 status, bytes memory data) = "https://httpbin.org/post".post(headers, '{"foo": "bar"}');

        assertEq(status, 200);
        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("foo").toSlice()));
        assertTrue(responseText.contains(("bar").toSlice()));
    }
}
