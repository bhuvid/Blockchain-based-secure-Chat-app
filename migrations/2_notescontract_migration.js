const chatContract = artifacts.require("Payment");

module.exports = function (deployer) {
  deployer.deploy(chatContract);
};
