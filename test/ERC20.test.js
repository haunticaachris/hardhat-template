const { expect } = require("chai");
const hre = require("hardhat");

describe("ERC20", async () => {
  let contract;
  const contractDecimals = 18;
  const contractName = "Test";
  const contractSymbol = "TEST";
  const totalSupply = ethers.utils.parseUnits("100", contractDecimals);

  beforeEach(async () => {
    await hre.network.provider.send("hardhat_reset");

    let Contract = await ethers.getContractFactory("ERC20Test");

    contract = await Contract.deploy(contractName, contractSymbol, totalSupply);

    await contract.deployed();
  });

  it("should correclty initialize contract", async () => {
    const [owner] = await ethers.getSigners();

    expect(await contract.balanceOf(owner.address)).to.equal(totalSupply);
    expect(await contract.decimals()).to.equal(contractDecimals);
    expect(await contract.name()).to.equal(contractName);
    expect(await contract.symbol()).to.equal(contractSymbol);
    expect(await contract.totalSupply()).to.equal(totalSupply);
  });

  it("should correctly approve spenders", async () => {
    const [owner, spender] = await ethers.getSigners();

    await contract.approve(spender.address, ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.allowance(owner.address, spender.address)).to.equal(
      ethers.utils.parseUnits("10", contractDecimals)
    );

    await expect(contract.approve(spender.address, ethers.utils.parseUnits("10", contractDecimals)))
      .to.emit(contract, "Approval")
      .withArgs(owner.address, spender.address, ethers.utils.parseUnits("10", contractDecimals));
  });

  it("should correctly transfer tokens", async () => {
    const [owner, to] = await ethers.getSigners();

    await contract.transfer(to.address, ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.balanceOf(to.address)).to.equal(ethers.utils.parseUnits("10", contractDecimals));
    expect(await contract.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("90", contractDecimals));

    await expect(
      contract.transfer(ethers.constants.AddressZero, ethers.utils.parseUnits("10", contractDecimals))
    ).to.be.revertedWith("ERC20: invalid address");

    await expect(
      contract.transfer(contract.address, ethers.utils.parseUnits("10", contractDecimals))
    ).to.be.revertedWith("ERC20: invalid address");

    await expect(contract.transfer(to.address, ethers.utils.parseUnits("200", contractDecimals))).to.be.revertedWith(
      "ERC20: insufficient balance"
    );

    await expect(contract.transfer(to.address, ethers.utils.parseUnits("10", contractDecimals)))
      .to.emit(contract, "Transfer")
      .withArgs(owner.address, to.address, ethers.utils.parseUnits("10", contractDecimals));
  });

  it("should correctly transfer tokens using transferFrom", async () => {
    const [owner, spender] = await ethers.getSigners();
    const spenderContract = await contract.connect(spender);

    await contract.approve(spender.address, ethers.utils.parseUnits("20", contractDecimals));

    await spenderContract.transferFrom(owner.address, spender.address, ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.balanceOf(spender.address)).to.equal(ethers.utils.parseUnits("10", contractDecimals));
    expect(await contract.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("90", contractDecimals));

    expect(await contract.allowance(owner.address, spender.address)).to.equal(
      ethers.utils.parseUnits("10", contractDecimals)
    );

    await expect(
      spenderContract.transferFrom(
        owner.address,
        ethers.constants.AddressZero,
        ethers.utils.parseUnits("10", contractDecimals)
      )
    ).to.be.revertedWith("ERC20: invalid address");

    await contract.approve(spender.address, ethers.utils.parseUnits("200", contractDecimals));

    await expect(
      spenderContract.transferFrom(owner.address, spender.address, ethers.utils.parseUnits("200", contractDecimals))
    ).to.be.revertedWith("ERC20: insufficient balance");

    await contract.approve(spender.address, ethers.utils.parseUnits("10", contractDecimals));

    await expect(
      spenderContract.transferFrom(owner.address, spender.address, ethers.utils.parseUnits("20", contractDecimals))
    ).to.be.revertedWith("ERC20: insufficient allowance");

    await expect(
      spenderContract.transferFrom(owner.address, spender.address, ethers.utils.parseUnits("10", contractDecimals))
    )
      .to.emit(contract, "Transfer")
      .withArgs(owner.address, spender.address, ethers.utils.parseUnits("10", contractDecimals));
  });

  it("should correctly mint tokens", async () => {
    const [owner] = await ethers.getSigners();

    await contract.mint(owner.address, ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.totalSupply()).to.equal(ethers.utils.parseUnits("110", contractDecimals));
    expect(await contract.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("110", contractDecimals));

    await expect(
      contract.mint(ethers.constants.AddressZero, ethers.utils.parseUnits("10", contractDecimals))
    ).to.be.revertedWith("ERC20: invalid address");
  });

  it("should correctly burn tokens", async () => {
    const [owner, spender] = await ethers.getSigners();
    const spenderContract = await contract.connect(spender);

    await contract.burn(ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.totalSupply()).to.equal(ethers.utils.parseUnits("90", contractDecimals));
    expect(await contract.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("90", contractDecimals));

    await expect(contract.burn(ethers.utils.parseUnits("200", contractDecimals))).to.be.revertedWith(
      "ERC20: insufficient balance"
    );

    await contract.approve(spender.address, ethers.utils.parseUnits("10", contractDecimals));

    await spenderContract.burnFrom(owner.address, ethers.utils.parseUnits("10", contractDecimals));

    expect(await contract.totalSupply()).to.equal(ethers.utils.parseUnits("80", contractDecimals));
    expect(await contract.balanceOf(owner.address)).to.equal(ethers.utils.parseUnits("80", contractDecimals));

    expect(await contract.allowance(owner.address, spender.address)).to.equal(
      ethers.utils.parseUnits("0", contractDecimals)
    );

    await expect(
      spenderContract.burnFrom(owner.address, ethers.utils.parseUnits("10", contractDecimals))
    ).to.be.revertedWith("ERC20: insufficient allowance");
  });
});
