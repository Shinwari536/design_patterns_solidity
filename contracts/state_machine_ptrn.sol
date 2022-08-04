// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
        ********** Problem **********
An application scenario implicates different behavioural stages
and transitions.

    ********** Solution **********

Apply a state machine to model and represent different behavioural contract stages and their transitions.

*/

contract DespoiteLock {
    // This is used in ICO & Staking contracts
    enum Stages {
        AcceptingDeposits,
        FreezingDeposits,
        ReleasingDeposits
    }

    Stages stage = Stages.AcceptingDeposits;
    uint256 creationTime = block.timestamp;
    mapping(address => uint256) balances;

    modifier atStage(Stages _stage) {
        require(stage == _stage, "Not expected stage.");
        _;
    }

    modifier timedTransitions() {
        if (
            stage == Stages.AcceptingDeposits &&
            creationTime > block.timestamp + 1 days
        ) {
            nextStage();
        }
        if (
            stage == Stages.FreezingDeposits &&
            creationTime > block.timestamp + 8 days
        ) {
            nextStage();
        }
        _;
    }

    function nextStage() internal {
        stage = Stages(uint256(stage) + 1);
    }

    function deposit()
        public
        payable
        timedTransitions
        atStage(Stages.AcceptingDeposits)
    {
        require(msg.value > 0);
        balances[msg.sender] = msg.value;
        // transfered ETH from msg.sender to contract or what logic is required.
    }

    function withdraw(uint256 _amount)
        public
        timedTransitions
        atStage(Stages.ReleasingDeposits)
    {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}
