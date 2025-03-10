//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Host, Result } from "@oasisprotocol/sapphire-contracts/contracts/OPL.sol";

contract HomeContract is Host {

    constructor(address otherEnd) 
        Host(otherEnd) 
    {
        registerEndpoint("myOtherFunction", myOtherFunction);
    }

    function myOtherFunction(bytes calldata _args)
        internal 
        returns(Result) 
    {
        (uint256 a, bool b) = abi.decode(_args, (uint256, bool));
        postMessage("myFunction", abi.encode(a,b));
        return Result.Success;
    }

    function triggerMessage(uint256 a, bool b) 
        external payable
    {
        postMessage("myFucntion", abi.encode(a,b));
    }

}