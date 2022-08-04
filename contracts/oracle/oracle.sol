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

contract Oracle {
    address knowSource = 0x09b58e6AE61dC52f08171E6cFD2fB2807f3CE19C; // known source (my own account just for example.) chance this address to a know source
    struct Request {
        bytes data;
        function(bytes memory) external callback;
    }

    Request[] requests;

    event NewRequest(uint256 requestId);

    modifier onlyBy() {
        require(msg.sender == knowSource);
        _;
    }

    function query(bytes memory data, function(bytes memory) external callback)
        public
    {
        requests.push(Request(data, callback));
        emit NewRequest(requests.length - 1);
    }

    function reply(uint256 requestId, bytes memory response) public onlyBy {
        requests[requestId].callback(response);
    }
}



