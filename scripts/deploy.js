const hre = require("hardhat");

/* Set contract name */
const contractName = "ERC20Test";

async function main() {
  await hre.run("compile");

  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contract with account: " + deployer.address);

  const Contract = await hre.ethers.getContractFactory(contractName);

  /* Set contract parameters and deploy */
  const contract = await Contract.deploy("Test Token", "TEST", hre.ethers.utils.parseUnits("100", 18));

  await contract.deployed();

  console.log("Contract deployed to: ", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);

    process.exit(1);
  });
