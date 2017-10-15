pragma solidity ^0.4.17;

contract Paper {

	enum Stages {
		submittedForPeerReview,
		peerReviewed,
		peerReviewsAcceptedByEditor,
		resubmittedForPeerReview,
		published,
		rejected
	}

	Stages public stage;
	string public title;
	address public author;
	address public editor;
	mapping (address => bool) isPeerReviewer;
	address[] public isPeerReviewerArray;
	mapping (address => bool) peerReviewerTracker;
	uint public peerReviewsToSubmit;
	address public addressOfPaper;
	uint public price;
	address public ethjournal;
	mapping (address => bool) public reader;

	function Paper(string _title, address _editor, address[] _peerReviewers,address _addressOfPaper, uint _price, address _ethjournal) public {
		author = msg.sender;
		title = _title;
		editor = _editor;
		isPeerReviewerArray = _peerReviewers;
		peerReviewsToSubmit = _peerReviewers.length;
		for (uint i = 0; i < _peerReviewers.length; i++) {
		    isPeerReviewer[_peerReviewers[i]] = true;
		    peerReviewerTracker[_peerReviewers[i]] = true;
		}
		addressOfPaper = _addressOfPaper;
		price = _price;
		ethjournal = _ethjournal;
		stage = Stages.submittedForPeerReview;
	}

	function submitPeerReview() public returns (bool) {
		require(peerReviewerTracker[msg.sender] && stage == Stages.submittedForPeerReview);
		peerReviewerTracker[msg.sender] = false;
		peerReviewsToSubmit--;
		if (peerReviewsToSubmit == 0) {
		    stage = Stages.peerReviewed;
		}
	}

	function deleteOwnPeerReview() public returns (bool) {
		require(isPeerReviewer[msg.sender] && stage == Stages.submittedForPeerReview);
		isPeerReviewer[msg.sender] = false;
		peerReviewerTracker[msg.sender] = false;
		peerReviewsToSubmit--;
		if (peerReviewsToSubmit == 0) {
		    stage = Stages.peerReviewed;
		}
	}

	function deletePeerReview(address _peerReviewer) public returns (bool) {
		require(msg.sender == editor && stage == Stages.submittedForPeerReview);
		isPeerReviewer[_peerReviewer] = false;
		peerReviewerTracker[_peerReviewer] = false;
		peerReviewsToSubmit--;
		if (peerReviewsToSubmit == 0) {
		    stage = Stages.peerReviewed;
		}
	}

	function publish() public returns (bool) {
		require(msg.sender == editor && stage == Stages.peerReviewed);
		stage = Stages.published;
	}

	function reject() public returns (bool) {
		require(msg.sender == editor && (stage == Stages.peerReviewed || stage == Stages.submittedForPeerReview));
		stage = Stages.rejected;
	}

	function revise() public returns (bool) {
		require(msg.sender == editor && stage == Stages.peerReviewed);
		stage = Stages.submittedForPeerReview;
	}

	modifier costs() {
		if (msg.value >= price) {
			_;
		}
	}

	function buy() public payable costs returns (bool) {
		require(stage == Stages.published);
		author.transfer(msg.value/2);
		editor.transfer(msg.value/4);
		address[] nonDeletedPeerReviewerArray;
		for (uint i = 0; i < isPeerReviewerArray.length; i++) {
			if (isPeerReviewer[isPeerReviewerArray[i]]) {
				nonDeletedPeerReviewerArray.push(isPeerReviewerArray[i]);
			}
		}
		for (uint peerReviewer = 0; peerReviewer < nonDeletedPeerReviewerArray.length; peerReviewer++) {
			nonDeletedPeerReviewerArray[peerReviewer].transfer(msg.value/(4*nonDeletedPeerReviewerArray.length));
		}
		reader[msg.sender] = true;
		return true;
	}

	function read() public returns (bool) {
		require(reader[msg.sender]);
		return true;
	}

	function() public payable {}

}
