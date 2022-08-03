// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
    ********** Problem **********
All data and every transaction is publicly visible on the
blockchain, but an application scenario requires that contract interactions,
speciﬁcally submitted parameter values, are treated conﬁdentially.

    ********** Solution **********
Apply a commitment scheme to ensure that a value submission
is binding and concealed until a consolidation phase runs out, after which
the value is revealed, and it is publicly veriﬁable that the value remained
unchanged. 
*/


contract CommitRevealPattern {
    struct Commit {
        string choice;
        string secret;
        string staus;
    }

    mapping(address => mapping(bytes32 => Commit)) public userCommits;

    event LogCommit(bytes32 _commit, address _committer);
    event LogReveal(
        bytes32 _commit,
        address _revealer,
        string _secret,
        string _choice
    );

    function createBytes(string memory _choice, string memory _secret)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_choice, _secret));
    }

    function commit(bytes32 _commit) public returns (bool success) {
        Commit storage userCommit = userCommits[msg.sender][_commit];
        if (bytes(userCommit.staus).length != 0) {
            // userCommit.staus == 0 applies that it is empty and not committed yet.
            return false; // commit has been used
        }
        userCommit.staus = "COMMIT"; // Data committed
        emit LogCommit(_commit, msg.sender);
    }

    function reveal(
        string memory _choice,
        string memory _secret,
        bytes32 _commit
    ) public returns (bool success) {
        Commit memory userCommit = userCommits[msg.sender][_commit];
        bytes memory bytesStatus = bytes(userCommit.staus);
        if (bytesStatus.length == 0) {
            return false; // not committed yet
        } else if (bytesStatus[0] == "R") {
            return false; // already revealed
        }
        if (_commit != keccak256(abi.encodePacked(_choice, _secret))) {
            return false; // hash does not match
        }
        userCommit.choice = _choice;
        userCommit.secret = _secret;
        userCommit.staus = "REVEAL"; // Data revealed

        emit LogReveal(_commit, msg.sender, _secret, _choice);
    }

    function traceCommit(address _address, bytes32 _commit)
        public
        view
        returns (
            string memory choice,
            string memory secret,
            string memory status
        )
    {
        Commit memory userCommit = userCommits[_address][_commit];
        if (bytes(userCommit.staus)[0] == "R") {
            return (userCommit.choice, userCommit.secret, userCommit.staus);
        }
    }
}
