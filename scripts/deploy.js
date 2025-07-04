// scripts/deploy.js

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("🚀 Deploying contracts with the account:", deployer.address);
  console.log("💰 Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("NawahToken"); // ← غيّر الاسم إن كان مختلفًا
  const token = await Token.deploy();

  await token.deployed();

  console.log("✅ NawahToken deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
