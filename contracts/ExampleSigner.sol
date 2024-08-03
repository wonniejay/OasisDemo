//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { EthereumUtils } from "@oasisprotocol/sapphire-contracts/contracts/EthereumUtils.sol";
import { EIP155Signer } from "@oasisprotocol/sapphire-contracts/contracts/EIP155Signer.sol";

interface RemoteContract {
    function example(uint256 test) external;
}

contract ExampleSigner {
    address public gaspayingAddress;
    bytes32 private gaspayingSecret;

    address public remoteContract;

    constructor(address _remoteContract) 
        payable
    {
        remoteContract = _remoteContract;
        (gaspayingAddress, gaspayingSecret) = EthereumUtils.generateKeypair();
    }

    //view call: does not pay any gas?
    function createTransaction(uint64 nonce, uint256 gasPrice, uint chainId) 
        public view returns (bytes memory)
    {
        EIP155Signer.EthTx memory ourTx = EIP155Signer.EthTx ({
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: 1000000,
            to: remoteContract,
            value: 0,
            data: abi.encodeCall(
                RemoteContract.example,
                (gasPrice)
            ),
            chainId: block.chainid
        });

        return EIP155Signer.sign(gaspayingAddress, gaspayingSecret, ourTx);
    }

    event TestEvent(uint example);

    function calledByOurselves(uint example) 
        public 
    {
        require( msg.sender == gaspayingAddress );

        emit TestEvent(1234);
    }
}

