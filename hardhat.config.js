require("dotenv").config();

module.exports = {
  networks: {
    bsctestnet: {
      url: process.env.BSCTESTNET_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY || "",
  },
  solidity: "0.8.18",
};
