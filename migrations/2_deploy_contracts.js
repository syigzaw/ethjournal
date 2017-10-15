var EthJournal = artifacts.require("./EthJournal.sol");
var Paper = artifacts.require("./Paper.sol");

module.exports = function(deployer) {
	deployer.deploy(EthJournal);
	deployer.deploy(Paper);
};
