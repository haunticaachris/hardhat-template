const { expect } = require("chai");
const hre = require("hardhat");

describe("ERC173", async () => {
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

  it("should transfer ownership correctly", async () => {
    const [contractOwner, newOwner, notOwner] = await ethers.getSigners();
    newOwnerContract = await contract.connect(newOwner);
    notOwnerContract = await contract.connect(notOwner);

    expect(await contract.owner()).to.equal(contractOwner.address);

    await contract.transferOwnership(newOwner.address);

    expect(await contract.owner()).to.equal(newOwner.address);

    await expect(newOwnerContract.transferOwnership(contractOwner.address))
      .to.emit(contract, "OwnershipTransferred")
      .withArgs(newOwner.address, contractOwner.address);

    await expect(notOwnerContract.transferOwnership(newOwner.address)).to.be.revertedWith("ERC173: unauthorized");
  });
});
