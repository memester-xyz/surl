// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Surl} from "src/Surl.sol";
import {strings} from "solidity-stringutils/strings.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract SurlTest is Test {
    using Surl for *;
    using strings for *;
    using stdJson for string;

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
        (uint256 status, bytes memory data) = "https://httpbin.org/post".post(headers, "formfield=myemail@ethereum.org");

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

    function testPut() public {
        (uint256 status,) = "https://httpbin.org/put".put();

        assertEq(status, 200);
    }

    function testPutJson() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        (uint256 status, bytes memory data) = "https://httpbin.org/put".put(headers, '{"foo": "bar"}');

        assertEq(status, 200);
        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(('"foo"').toSlice()));
        assertTrue(responseText.contains(('"bar"').toSlice()));
    }

    function testDelete() public {
        (uint256 status,) = "https://httpbin.org/delete".del();

        assertEq(status, 200);
    }

    function testPatch() public {
        (uint256 status,) = "https://httpbin.org/patch".patch();

        assertEq(status, 200);
    }

    // Swap 1 ETH for DAI on 1inch
    function test1InchAPI() public {
        string memory url = "https://api.1inch.dev/swap/v5.2/1/swap";
        string memory params = string.concat(
            "?from=",
            vm.toString(address(0)),
            "&src=",
            vm.toString(address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)),
            "&dst=",
            vm.toString(address(0x6B175474E89094C44Da98b954EedeAC495271d0F)),
            "&amount=",
            vm.toString(uint256(1 ether)),
            "&slippage=",
            vm.toString(uint256(3))
        );

        string memory apiKey = vm.envString("ONEINCH_API_KEY");

        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] = string.concat("Authorization: Bearer ", apiKey);

        string memory request = string.concat(url, params);
        (uint256 status, bytes memory res) = request.get(headers);

        assertEq(status, 200);

        string memory json = string(res);

        address target = json.readAddress(".tx.to");
        bytes memory data = json.readBytes(".tx.data");

        assertEq(target, address(0x1111111254EEB25477B68fb85Ed929f73A960582));
        assertGt(data.length, 0);
    }
}
