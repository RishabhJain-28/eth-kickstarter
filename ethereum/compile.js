const solc = require("solc");
const path = require("path");
const fs = require("fs-extra");

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");

const buildPath = path.resolve(__dirname, "build");

function compile() {
  fs.removeSync(buildPath);
  const campaignSource = fs.readFileSync(campaignPath, "utf8");
  const output = solc.compile(campaignSource, 1).contracts;

  fs.ensureDirSync(buildPath);

  for (let contract in output) {
    const p = path.resolve(buildPath, contract.slice(1) + ".json");
    fs.outputJsonSync(p, output[contract]);
  }
}

compile();
