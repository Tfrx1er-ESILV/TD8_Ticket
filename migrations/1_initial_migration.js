const ticketingSystem = artifacts.require("ticketingSystem");
const Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(ticketingSystem);
};
