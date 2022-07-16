import { expect } from "chai";
import { ethers, waffle } from "hardhat";
import { ERC20 } from "../typechain-types/lib/ERC20";
import { Will } from "../typechain-types/Will";
import { ERC20__factory } from "../typechain-types/factories/lib/ERC20__factory";
import { Will__factory } from "../typechain-types/factories/Will__factory";
import { MockProvider } from "ethereum-waffle";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

const { provider } = waffle;

describe("Vault", function () {
  let token: ERC20;
  let will: Will;
  const [wallet] = provider.getWallets();
  let signers: SignerWithAddress[];

  before(async function () {
    signers = await ethers.getSigners();
    const deployer = new ERC20__factory(signers[0]);
    token = await deployer.deploy("token", "TKN");
    await token.mint(signers[0].address, ethers.utils.parseEther("100"));
  });

  before(async function () {
    signers = await ethers.getSigners();
    const deployer = new Will__factory(signers[0]);
    will = await deployer.deploy(signers[0].address, 60, signers[1].address);
  });

});
