const Test = artifacts.require("Test");

module.exports = function (deployer) {
  deployer.deploy(Test);
} as Truffle.Migration;

export {};


