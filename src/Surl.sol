// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Vm} from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";


library Surl {

    Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    function get(string memory self) internal returns (uint256 status, bytes memory data) {
        string[] memory headers = new string[](0);
        return get(self, headers);
    }

    function get(string memory self, string[] memory headers) internal returns (uint256 status, bytes memory data) {
        string memory curlParams = "";

        for(uint256 i = 0; i < headers.length; i++) {
            curlParams = string.concat(curlParams, "-H \"", headers[i], "\" ");
        }

        string[] memory inputs = new string[](3);
        inputs[0] = "sh";
        inputs[1] = "-c";
        inputs[2] = string(
            bytes.concat('./src/curl.sh ', bytes(curlParams), bytes(self), "")
        );
        console.log(inputs[2]);
        bytes memory res = vm.ffi(inputs);

        (status, data) = abi.decode(res, (uint256, bytes));
    }
}
