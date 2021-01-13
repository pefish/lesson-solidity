import { TestInstance } from "../types/truffle-contracts";

const Test = artifacts.require("Test.sol");

contract('Test', (accounts) => {

  it('storeWords', async () => {
    const testInstance: TestInstance = await Test.deployed();
    
    const result = await testInstance.getImportedA()
    console.log(result)
    // assert.equal(!!result.tx, true, "storeWords error");
  });

});
