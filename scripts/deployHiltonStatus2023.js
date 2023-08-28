const hre = require('hardhat');

async function main() {

  const HiltonStatus2023 = await hre.ethers.getContractFactory(
    'HiltonStatus2023',
  );

  const name = "HiltonStatus2023"
  const symbol = "HS2023"

  const hiltonStatus2023 = await HiltonStatus2023.deploy(
    name,
    symbol
  );

  await hiltonStatus2023.waitForDeployment();

  console.log(`hiltonStatus2023 deployed to ${await hiltonStatus2023.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});