const path = require("path");
const Web3 = require("web3");
const HDWalletProvider = require("truffle-hdwallet-provider");
require("dotenv").config({ path: path.resolve(__dirname, "../", ".env") });

const compiledFactory = require("../ethereum/build/CampaignFactory.json");

const provider = new HDWalletProvider(
  process.env.MNEMONIC,
  process.env.RINKBY_ENDPOINT
);

const web3 = new Web3(provider);

async function deploy() {
  const accounts = await web3.eth.getAccounts();
  const campaignFactoryContratct = await new web3.eth.Contract(
    JSON.parse(compiledFactory.interface)
  )
    .deploy({ data: compiledFactory.bytecode })
    .send({ from: accounts[0], gas: "1000000" });
  console.log(
    "address of the contract : ",
    campaignFactoryContratct.options.address
  );
}

deploy();
