import { ProxyInstance, TestInstance } from "../types/truffle-contracts";

const UpgradeabilityProxy = artifacts.require("Proxy");
const Test = artifacts.require("Test");

contract('Proxy', (accounts) => {
  let upgradeabilityProxyInstance: ProxyInstance
  let testInstance: TestInstance

  beforeEach(async function () {
    testInstance = await Test.new()
    upgradeabilityProxyInstance = await UpgradeabilityProxy.new(testInstance.address);
  });


  it('storeWords getWords', async () => {
    // @ts-ignore
    let upgradeabilityProxyContract = new web3.eth.Contract(Test.abi, upgradeabilityProxyInstance.address)

    await upgradeabilityProxyContract.methods["storeA"](123).send({
      from: accounts[0],
    })
    const result = await upgradeabilityProxyContract.methods["a"]().call()
    // console.log(result1)
    assert.equal(result, 123, "getWords error");


    await upgradeabilityProxyContract.methods["storeWords"](accounts[0]).send({
      from: accounts[0],
    })
    const result1 = await upgradeabilityProxyContract.methods["getWords"]().call()
    // console.log(result1)
    assert.equal(result1, accounts[0], "getWords error");
  });

});
