const Migrations = artifacts.require("Migrations");
const Splitter = artifacts.require("Splitter");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Splitter);
};
