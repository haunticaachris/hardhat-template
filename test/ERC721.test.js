const { expect } = require("chai");
const hre = require("hardhat");

describe("ERC721", async () => {
  let contract;
  const contractName = "Test";
  const contractSymbol = "TEST";

  beforeEach(async () => {
    await hre.network.provider.send("hardhat_reset");

    let Contract = await ethers.getContractFactory("ERC721Test");

    contract = await Contract.deploy(contractName, contractSymbol);

    await contract.deployed();
  });

  it("should correctly initialize a contract", async () => {
    const [owner] = await ethers.getSigners();

    expect(await contract.name()).to.equal(contractName);

    expect(await contract.ownerOf(0)).to.equal(owner.address);

    await expect(contract.ownerOf(1)).to.be.revertedWith("ERC721: invalid token");

    expect(await contract.symbol()).to.equal(contractSymbol);

    expect(await contract.totalSupply()).to.equal(1);
  });

  it("should correctly approve an address", async () => {
    const [owner, approved, notOwner] = await ethers.getSigners();
    const approvedContract = await contract.connect(approved);
    const notOwnerContract = await contract.connect(notOwner);

    await contract.approve(approved.address, 0);

    expect(await contract.getApproved(0)).to.equal(approved.address);

    await contract.setApprovalForAll(approved.address, true);

    await approvedContract.approve(approved.address, 0);

    expect(await contract.getApproved(0)).to.equal(approved.address);

    await expect(notOwnerContract.approve(ethers.constants.AddressZero, 0)).to.be.revertedWith("ERC721: unauthorized");

    await expect(contract.getApproved(1)).to.be.revertedWith("ERC721: invalid token");

    await expect(contract.approve(approved.address, 0))
      .to.emit(contract, "Approval")
      .withArgs(owner.address, approved.address, 0);

    await expect(contract.internalApprove(notOwner.address, notOwner.address, 0)).to.be.revertedWith(
      "ERC721: invalid address"
    );
  });

  it("should correctly return balance", async () => {
    const [owner] = await ethers.getSigners();

    expect(await contract.balanceOf(owner.address)).to.equal(1);

    await expect(contract.balanceOf(ethers.constants.AddressZero)).to.be.revertedWith("ERC721: invalid address");
  });

  it("should correctly transfer tokens with safeTransferFrom", async () => {
    const [owner, to] = await ethers.getSigners();
    const toContract = await contract.connect(to);

    await contract["safeTransferFrom(address,address,uint256)"](owner.address, to.address, 0);

    expect(await contract.balanceOf(to.address)).to.equal(1);
    expect(await contract.balanceOf(owner.address)).to.equal(0);

    await toContract["safeTransferFrom(address,address,uint256,bytes)"](
      to.address,
      owner.address,
      0,
      ethers.utils.toUtf8Bytes("")
    );

    expect(await contract.balanceOf(to.address)).to.equal(0);
    expect(await contract.balanceOf(owner.address)).to.equal(1);
  });

  it("should correctly transfer tokens with safeTransferFrom to contract", async () => {
    const [owner] = await ethers.getSigners();

    let Contract = await ethers.getContractFactory("ERC721TokenReceiverTest");

    let to = await Contract.deploy(true);

    await to.deployed();

    await contract["safeTransferFrom(address,address,uint256)"](owner.address, to.address, 0);

    expect(await contract.balanceOf(to.address)).to.equal(1);
    expect(await contract.balanceOf(owner.address)).to.equal(0);

    Contract = await ethers.getContractFactory("ERC721Test");

    contract = await Contract.deploy(contractName, contractSymbol);

    await contract.deployed();

    Contract = await ethers.getContractFactory("ERC721TokenReceiverTest");

    to = await Contract.deploy(false);

    await to.deployed();

    await expect(
      contract["safeTransferFrom(address,address,uint256)"](owner.address, to.address, 0)
    ).to.be.revertedWith("ERC721: onERC721Received");

    Contract = await ethers.getContractFactory("ERC721Test");

    contract = await Contract.deploy(contractName, contractSymbol);

    await contract.deployed();

    Contract = await ethers.getContractFactory("ERC20Test");

    to = await Contract.deploy("Test", "TEST", ethers.utils.parseUnits("100", 18));

    await contract.deployed();

    await expect(
      contract["safeTransferFrom(address,address,uint256)"](owner.address, to.address, 0)
    ).to.be.revertedWith("ERC721: onERC721Received");
  });

  it("should correctly approve an operator", async () => {
    const [owner, approved] = await ethers.getSigners();

    await contract.setApprovalForAll(approved.address, true);

    expect(await contract.isApprovedForAll(owner.address, approved.address)).to.equal(true);

    await expect(contract.setApprovalForAll(approved.address, true))
      .to.emit(contract, "ApprovalForAll")
      .withArgs(owner.address, approved.address, true);
  });

  it("should correctly transfer tokens with transferFrom", async () => {
    const [owner, to, approved] = await ethers.getSigners();
    const approvedContract = await contract.connect(approved);

    await contract.transferFrom(owner.address, to.address, 0);

    expect(await contract.balanceOf(to.address)).to.equal(1);
    expect(await contract.balanceOf(owner.address)).to.equal(0);

    await contract.mint(owner.address, 1);

    await contract.approve(approved.address, 1);

    await approvedContract.transferFrom(owner.address, approved.address, 1);

    expect(await contract.getApproved(1)).to.equal(ethers.constants.AddressZero);

    await expect(contract.transferFrom(owner.address, to.address, 2)).to.be.revertedWith("ERC721: invalid token");

    await contract.mint(owner.address, 2);

    await expect(contract.transferFrom(ethers.constants.AddressZero, to.address, 2)).to.be.revertedWith(
      "ERC721: invalid address"
    );

    await expect(contract.transferFrom(owner.address, contract.address, 2)).to.be.revertedWith(
      "ERC721: invalid address"
    );

    await contract.mint(owner.address, 3);

    await expect(contract.transferFrom(owner.address, ethers.constants.AddressZero, 3)).to.be.revertedWith(
      "ERC721: invalid address"
    );

    await contract.mint(owner.address, 4);

    const toContract = await contract.connect(to);

    await expect(toContract.transferFrom(owner.address, to.address, 4)).to.be.revertedWith("ERC721: unauthorized");
  });

  it("should correctly burn tokens", async () => {
    const [owner, address] = await ethers.getSigners();
    const addressContract = await contract.connect(address);

    await contract.burn(0);

    expect(await contract.balanceOf(owner.address)).to.equal(0);

    await expect(contract.burn(1)).to.be.revertedWith("ERC721: invalid token");

    await contract.mint(owner.address, 0);

    await expect(addressContract.burn(0)).to.be.revertedWith("ERC721: unauthorized");

    await expect(contract.burnOwner(1)).to.be.revertedWith("ERC721: invalid token");
  });

  it("should correctly mint tokens", async () => {
    const [owner] = await ethers.getSigners();

    await contract.mint(owner.address, 1);

    expect(await contract.balanceOf(owner.address)).to.equal(2);

    await expect(contract.mint(ethers.constants.AddressZero, 2)).to.be.revertedWith("ERC721: invalid address");
    await expect(contract.mint(contract.address, 2)).to.be.revertedWith("ERC721: invalid address");

    await expect(contract.mint(owner.address, 0)).to.be.revertedWith("ERC721: invalid token");
  });

  it("should return correct values from supportsInterface", async () => {
    expect(await contract.supportsInterface("0xffffffff")).to.equal(false);
    expect(await contract.supportsInterface("0x00000000")).to.equal(false);
    expect(await contract.supportsInterface("0x01ffc9a7")).to.equal(true);
    expect(await contract.supportsInterface("0x80ac58cd")).to.equal(true);
    expect(await contract.supportsInterface("0x780e9d63")).to.equal(true);
    expect(await contract.supportsInterface("0x5b5e139f")).to.equal(true);
    expect(await contract.supportsInterface("0x7f5828d0")).to.equal(true);
  });

  it("should correctly enumerate tokens", async () => {
    const [owner, to] = await ethers.getSigners();

    expect(await contract.tokenByIndex(0)).to.equal(0);

    await contract.mint(owner.address, 1);
    await contract.mint(owner.address, 2);
    await contract.mint(owner.address, 3);
    await contract.mint(owner.address, 4);

    let totalSupply = await contract.totalSupply();

    expect(totalSupply).to.equal(5);

    await contract.transferFrom(owner.address, to.address, 0);
    await contract.transferFrom(owner.address, to.address, 1);

    expect(await contract.tokenOfOwnerByIndex(owner.address, 0)).to.equal(4);
    expect(await contract.tokenOfOwnerByIndex(owner.address, 1)).to.equal(3);
    expect(await contract.tokenOfOwnerByIndex(owner.address, 2)).to.equal(2);

    expect(await contract.tokenOfOwnerByIndex(to.address, 0)).to.equal(0);
    expect(await contract.tokenOfOwnerByIndex(to.address, 1)).to.equal(1);

    await expect(contract.tokenByIndex(999)).to.be.revertedWith("ERC721: invalid token");

    await expect(contract.tokenOfOwnerByIndex(ethers.constants.AddressZero, 1)).to.be.revertedWith(
      "ERC721: invalid token"
    );
    await expect(contract.tokenOfOwnerByIndex(owner.address, 999)).to.be.revertedWith("ERC721: invalid token");
  });

  it("should return the correct token URI", async () => {
    await contract.setTokenURI(0, "test");

    expect(await contract.tokenURI(0)).to.equal("test");

    await expect(contract.tokenURI(1)).to.be.revertedWith("ERC721: invalid token");

    await expect(contract.setTokenURI(1, "test")).to.be.revertedWith("ERC721: invalid token");
  });
});
