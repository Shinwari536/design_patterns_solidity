// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


/** 
    ********** Problem **********
A usage scenario requires a temporal constraint defining a point
in time when functions become deprecated.

    ********** Solution **********
Define an expiration time and apply modifiers in function
definitions to disable function execution if the expiration date has been
reached.

*/

contract AutoDeprecate{
    uint256 private expires;

    modifier willDeprecate() {
        require(!expired());
        _;
    }

     modifier whenDeprecated() {
        require(expired());
        _;
    }

    constructor(uint256 _days){
        expires = block.timestamp + _days * 1 days;
    }

    function expired() internal view returns(bool){
        return block.timestamp > expires;
    }

    function deposit() public payable willDeprecate {
        // deposit code
    }

    function withdraw() public whenDeprecated{
        // withdaw code
    }
}