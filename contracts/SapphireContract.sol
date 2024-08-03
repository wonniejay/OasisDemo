//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Enclave, autoswitch, Result } from "@oasisprotocol/sapphire-contracts/contracts/OPL.sol";

contract SapphireContract is Enclave { 

    constructor(address otherEnd, bytes32 chain) 
        Enclave(otherEnd, autoswitch(chain)) 
    {
        registerEndpoint("myFunction", myFunction);
    }

    // Passed thorugh the message bus
    function myFunction(bytes calldata _args)
        internal 
        returns(Result) 
    {
        (uint256 a, bool b) = abi.decode(_args, (uint256, bool));
        postMessage("myOtherFunction", abi.encode(a,b));
        return Result.Success;
    }
    
}