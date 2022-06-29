#!/bin/bash

response=$(curl -s -w "\n%{http_code}" $@)
echo $response
status=$(tail -n1 <<< "$response")  # get the last line
data=$(sed '$ d' <<< "$response")   # get all but the last line which contains the status code

data=$(echo "$data" | tr -d '\n')

cast abi-encode "response(uint256,string)" "$status" "$data"
