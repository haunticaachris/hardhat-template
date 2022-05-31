const { expect } = require("chai");
const hre = require("hardhat");

describe("ERC165", async () => {
  let contract;
  const contractName = "Test";
  const contractSymbol = "TEST";
  const totalSupply = ethers.utils.parseUnits("100", 18);

  beforeEach(async () => {
    await hre.network.provider.send("hardhat_reset");

    let Contract = await ethers.getContractFactory("ERC20Test");

    contract = await Contract.deploy(contractName, contractSymbol, totalSupply);

    await contract.deployed();
  });

  it("should return correct values for supportsInterface", async () => {
    expect(await contract.supportsInterface("0x01ffc9a7")).to.equal(true);
    expect(await contract.supportsInterface("0x7f5828d0")).to.equal(true);
    expect(await contract.supportsInterface("0xffffffff")).to.equal(false);
    expect(await contract.supportsInterface("0x00000000")).to.equal(false);
  });
});
