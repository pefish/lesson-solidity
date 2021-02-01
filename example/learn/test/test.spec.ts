import { TestInstance, Test1Instance } from "../types/truffle-contracts";

const Test = artifacts.require("Test");
const Test1 = artifacts.require("Test1");

contract('Test', (accounts) => {
  let testInstance: TestInstance
  let test1Instance: Test1Instance

  beforeEach(async function () {
    testInstance = await Test.new();
    test1Instance = await Test1.new();
  });

  it('getImportedA', async () => {
    const result = await testInstance.getImportedA()
    assert.equal(result.toNumber(), 123, "getImportedA error");
  });

  it('getImportedA1', async () => {
    try {
      const result = await testInstance.getImportedA1()
    } catch (err) {
      assert.equal(!!err, true);
      assert.equal(err.message, "Returned error: VM Exception while processing transaction: revert not xiaohong");
    }
  });

  it('getImportedA2', async () => {
    try {
      const result = await testInstance.getImportedA2()
    } catch (err) {
      assert.equal(!!err, true);
      assert.equal(err.message, "Returned error: VM Exception while processing transaction: revert not xiaohong");
    }
  });

  it('setName', async () => {
    const tx = await testInstance.setName("newName")
    // console.log(tx.receipt.from)
    assert.equal(tx.logs[0].event, "NameChanged", "setName error");
    assert.equal(tx.logs[0].args["who"].toLowerCase(), tx.receipt.from, "setName error");
    assert.equal(tx.logs[0].args["name"], "newName", "setName error");

    const result = await testInstance.getName()
    assert.equal(result, "newName", "setName error");
  });

  it('testTransfer', async () => {
    try {
      await testInstance.testTransfer({
        value: "100",
      })
    } catch (err) {
      assert.equal(!!err, true);
    }
  });

  it('testSend', async () => {
    const result = await testInstance.testSend({
      value: "100",
    })
    assert.equal(1, 1);
  });

  it('testArrayAction', async () => {
    const result = await testInstance.testArrayLength()
    assert.equal(result.toNumber(), 0);
    await testInstance.testArrayAction()
    const result1 = await testInstance.testArrayLength()
    assert.equal(result1.toNumber(), 1);
  });

  it('getTypeName', async () => {
    const result = await testInstance.getTypeName()
    assert.equal(result, "Test");
  });

  it('testVar', async () => {
    const result = await testInstance.testVar()
    assert.equal(result.toString(), "1000000000000");
  });

  it('fallback receive', async () => {
    try {
      const result = await testInstance["send"](1, {
        gas: 21000,
      })
    } catch (err) {
      assert.equal(err.message.indexOf("out of gas") !== -1, true)
    }
  });

  it('call test1', async () => {
    try {
      const result = await testInstance.callTest1(test1Instance.address)
    } catch (err) {
      assert.equal((await testInstance.a()).toString(), "0")
      assert.equal((await test1Instance.a()).toString(), "0")
    }
  });

});
