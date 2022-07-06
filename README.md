# <h1 align="center"> surl </h1>

**Perform web requests from Solidity scripts/tests**

![Github Actions](https://github.com/memester-xyz/surl/workflows/test/badge.svg)

## Installation

```
forge install memester-xyz/surl
```

## Usage

1. Add this import to your script or test:
```solidity
import {Surl} from "surl/Surl.sol";
```

2. Add this directive inside of your Contract:
```solidity
using Surl for *;
```

2. Make your HTTP requests:
```solidity
// Perform a simple get request
(uint256 status, bytes memory data) = "https://httpbin.org/get".get();

// Perform a get request with headers
string[] memory headers = new string[](2);
headers[0] = "accept: application/json";
headers[1] = "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==";
(uint256 status, bytes memory data) = "https://httpbin.org/get".get(headers);

// Perform a post request with headers and JSON body
string[] memory headers = new string[](1);
headers[0] = "Content-Type: application/json";
(uint256 status, bytes memory data) = "https://httpbin.org/post".post(headers, '{"foo": "bar"}');

// Perform a put request
(uint256 status, bytes memory data) = "https://httpbin.org/put".put();

// Perform a patch request
(uint256 status, bytes memory data) = "https://httpbin.org/put".patch();

// Perform a delete request (unfortunately 'delete' is a reserved keyword and cannot be used as a function name)
(uint256 status, bytes memory data) = "https://httpbin.org/delete".del();
```

3. You must enable [ffi](https://book.getfoundry.sh/cheatcodes/ffi.html) in order to use the library. You can either pass the `--ffi` flag to any forge commands you run (e.g. `forge script Script --ffi`), or you can add `ffi = true` to your `foundry.toml` file.

### Notes

 - It assumes you are running on a UNIX based machine with `bash`, `tail`, `sed`, `tr`, `curl` and `cast` installed.

## Example

We have example usage for both [tests](./test/Surl.t.sol) and [scripts](./script/).

## Contributing

Clone this repo and run:

```
forge install
```

Make sure all tests pass, add new ones if needed:

```
forge test
```

## Why?

[Forge scripting](https://book.getfoundry.sh/tutorials/solidity-scripting.html) is becoming more popular. With Solenv your scripts are even more powerful and natural to work with.

## Goes well with:

 * [Solenv](https://github.com/memester-xyz/solenv): Load .env files in Solidity scripts/tests.
 * A JSON parser? We found some in-progress work on this front, but nothing quite ready. If you're working on a JSON parser in Solidity, please let us know.

## Development

This project uses [Foundry](https://getfoundry.sh). See the [book](https://book.getfoundry.sh/getting-started/installation.html) for instructions on how to install and use Foundry.
