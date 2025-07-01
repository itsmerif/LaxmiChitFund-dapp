async function main() {
  const LaxmiChitFund = await ethers.getContractFactory("LaxmiChitFund");
  const fund = await LaxmiChitFund.deploy();
  await fund.waitForDeployment();

  console.log("LaxmiChitFund deployed to:", fund.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

