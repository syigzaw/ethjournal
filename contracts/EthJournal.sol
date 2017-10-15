pragma solidity ^0.4.17;

import './Paper.sol';

contract EthJournal {
	// mapping (address => uint) balances;

	mapping (address => bool) public authors;
	mapping (address => bool) public editors;
	mapping (address => address[]) public usersPapers;
	Paper[] public papers;

	function authorSignUp(address user) returns (bool) {
		require(!authors[user]);
		authors[user] = true;
		return true;
	}

	function editorSignUp(address user) returns (bool) {
		require(!editors[user]);
		editors[user] = true;
		return true;
	}

	function createPaper(string _title, address[] _authors, address _addressOfPaper, uint _price) returns (Paper) {
		address editor;
		address[] peerReviewers;
		Paper newPaper = new Paper(_title, _authors, editor, peerReviewers, _addressOfPaper, _price, this);
		return newPaper;
	}

	function addPaper(address _paper) {
		usersPapers[Paper(_paper).author].push(_paper);
		papers.push(_paper);
	}

}
