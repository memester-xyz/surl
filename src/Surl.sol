// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Vm} from "forge-std/Vm.sol";

library Surl {
    Vm constant vm =
        Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    function get(string memory self)
        internal
        returns (uint256 status, bytes memory data)
    {
        string[] memory empty = new string[](0);
        return get(self, empty);
    }

    function get(string memory self, string[] memory headers)
        internal
        returns (uint256 status, bytes memory data)
    {
        return curl(self, headers, "", "GET");
    }

    function post(
        string memory self,
        string[] memory headers,
        string memory body
    )
        internal
        returns (uint256 status, bytes memory data)
    {
        return curl(self, headers, body, "POST");
    }

    function curl(
        string memory self,
        string[] memory headers,
        string memory body,
        string memory method
    )
        internal
        returns (uint256 status, bytes memory data)
    {
        string memory curlParams = "";

        for (uint256 i = 0; i < headers.length; i++) {
            curlParams = string.concat(curlParams, "-H \"", headers[i], "\" ");
        }

        curlParams = string.concat(curlParams, " -X ", method, " ");

        if (bytes(body).length > 0) {
            curlParams = string.concat(curlParams, " -d \"", body, "\" ");
        }

        string[] memory inputs = new string[](3);
        inputs[0] = "sh";
        inputs[1] = "-c";
        inputs[2] = string(
            bytes.concat('./src/curl.sh ', bytes(curlParams), bytes(self), "")
        );
        bytes memory res = vm.ffi(inputs);

        (status, data) = abi.decode(res, (uint256, bytes));
    }
}