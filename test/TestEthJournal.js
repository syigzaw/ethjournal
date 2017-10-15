pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthJournal.sol";
import "../contracts/Paper.sol";

contract TestEthJournal {

    address public author;
    address public editor;
    address public peerReviewer1;
    address public peerReviewer2;
    address public peerReviewer3;
    address[] public peerReviewerArray;

    function TestEthJournal() {
        author = 0xa663db2cfefc592c14d180ab81e0e6b397bf9e5d;
        editor = 0x5b6a0425891d87909775b37d5a20b023a6e2f890;
        peerReviewer1 = 0xc55b7aeecb471a24978b5108fb06efaad10aad9c;
        peerReviewer2 = 0x22c232bd7fd7c4221f3ea4ec4940232bbf865e7e;
        peerReviewer3 = 0x94d01f29b16cb631b77ed77ddf6db9c44c597d96;
        peerReviewerArray = [author, peerReviewer1, peerReviewer2, peerReviewer3];
    }

    function testCreatePaper() {
        EthJournal ethjournal = EthJournal(DeployedAddresses.EthJournal());
        Assert.isTrue(ethjournal.authorSignUp(author), 'Author did not sign up.');
        Assert.isTrue(ethjournal.editorSignUp(editor), 'Editor did not sign up.');
        ethjournal.createPaper('Hello World', 1, 10);
    }

}
