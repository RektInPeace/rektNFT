require('dotenv').config();
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Rekt, ImageTest, Rekt__factory, ImageTest__factory } from "../../artifacts/typchain-types/";
import { BigNumberish, Signer } from "ethers";



describe("Rekt", function () {
  let rektContract: Rekt
  let imageTestContract: ImageTest
  let owner: Signer, addr1, addr2, addr3, addrs
  let ImageTest, Rekt
  let baseURL = "https://localhost:5000/token/"
  beforeEach(async function () {
    ImageTest = await ethers.getContractFactory("ImageTest") as ImageTest__factory
    imageTestContract = await ImageTest.deploy()
    Rekt = await ethers.getContractFactory("Rekt") as Rekt__factory

    rektContract = await Rekt.deploy(baseURL)
    rektContract.on("Mint", (sender: string, tokenId: BigNumberish, rektDetails: any) => {
      console.log(sender, tokenId, rektDetails);
    });
    ;[owner, addr1, addr2, addr3] = await ethers.getSigners()
  })
  async function mint3ImageTest() {
    await imageTestContract.mint()
    await imageTestContract.mint()
    await imageTestContract.mint()
  }
  async function mint3Rekt() {
    await mint3ImageTest()
    const overrides = {
      value: ethers.utils.parseEther('0.02'),
    }
    await rektContract.mintWithID(
      imageTestContract.address,
      1,
      "Rekt in "
      , overrides
    )
    await rektContract.mintWithID(
      imageTestContract.address,
      2,
      "Rekt in 2"
      , overrides
    )
    await rektContract.mintWithID(
      imageTestContract.address,
      3,
      "Rekt in 3"
      , overrides
    )
  }

  describe("Deployment", async function () {
    it("Should set the right owner", async function () {
      const _owner = await rektContract.owner()
      expect(_owner).to.equal(await owner.getAddress());
    });
    it("Should default the right mint price", async function () {
      const price = await rektContract.price()
      expect( ethers.utils.formatEther(price) ).to.equal("0.02")
    })
    it("Should set a new mint price", async function () {
      await rektContract.setPrice( ethers.utils.parseEther("0.04") )
      const price = await rektContract.price()
      expect( ethers.utils.formatEther(price) ).to.equal("0.04")
    })
  })

  describe("Mint", async function () {

    it("Should Mint 3 Square NFTs", async function () {
      await mint3ImageTest()
      expect(await imageTestContract._tokenIds()).to.equal(4)
    })

    it("Should Mint 3 Rekt NFTs", async function () {
      await mint3Rekt()
      expect(await rektContract.totalMinted()).to.equal(3)
      expect(await rektContract.tokenURI(0)).to.equal(baseURL + "0");
    })
  })
  describe("Withdraw", async function () {
    it("Should withdraw", async function () {
      await mint3Rekt()
      const balance = await ethers.provider.getBalance(rektContract.address);
      expect( ethers.utils.formatEther(balance) ).to.equal("0.06")
      const withdrawTx = await rektContract.withdraw()
      await withdrawTx.wait()
      const afterBalance = await ethers.provider.getBalance(rektContract.address)

      expect( ethers.utils.formatEther(afterBalance) ).to.equal("0.0")
    })
  })

})

