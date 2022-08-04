// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/** 
    ********** Problem **********
An application scenario requires knowledge contained outside
the blockchain, but Ethereum contracts cannot directly acquire information
from the outside world. On the contrary, they rely on the outside world
pushing information into the network.

    ********** Solution **********
Request external data through an oracle service that is connected
to the outside world and acts as a data carrier

*/
import "./oracle.sol";

contract OracleConsumer{
    Oracle oracle = Oracle(address(this));

     modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    function updateExchangeRate() public{
        oracle.query("USD", this.oracleResponse);
    }

    function oracleResponse(bytes memory response) public onlyBy(address(oracle)){
        // use the data
    }

}