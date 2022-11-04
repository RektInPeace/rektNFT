import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Rekt, ImageTest, Rekt__factory, ImageTest__factory } from "../../artifacts/typchain-types/";
import { BigNumberish, Signer } from "ethers";



describe("Rekt", function () {
  let rektContract: Rekt
  let imageTestContract:ImageTest
  let owner: Signer, addr1, addr2, addr3, addrs
  let ImageTest, Rekt
  let baseURL = "https://localhost:5000/token/"
  beforeEach(async function() {
    ImageTest = await ethers.getContractFactory("ImageTest") as ImageTest__factory
    imageTestContract = await ImageTest.deploy()
    Rekt = await ethers.getContractFactory("Rekt") as Rekt__factory
    
    rektContract = await Rekt.deploy(baseURL)
    rektContract.on("Mint", (sender: string, tokenId: BigNumberish, rektDetails: any) => {
      console.log(sender, tokenId, rektDetails);
    });
    ;[owner, addr1, addr2, addr3] = await ethers.getSigners()

  })

  describe("Deployment", async function () {
    it("Should set the right owner", async function () {
      const _owner = await rektContract.owner()
      expect(_owner).to.equal(await owner.getAddress());
    });
    it("Should default the right mint price", async function () {
      const price = await rektContract.price()  
      const priceString = ethers.utils.formatEther(price);
      expect(priceString).to.equal("0.02")
    })
    it("Should set a new mint price", async function () {
      const setPrice = ethers.utils.parseEther("0.04")
      await rektContract.setPrice(setPrice)  
      const price = await rektContract.price() 
      const priceString = ethers.utils.formatEther(price);
      expect(priceString).to.equal("0.04")
    })
  })

  describe("Mint", async function () {

    it("Should Mint Square NFT", async function() {
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(2)   
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(3)   
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(4)   
    })

     it("Should Mint Rekt NFT", async function () {

      await imageTestContract.mint()
      const overrides = {
        value: ethers.utils.parseEther('0.02'),
      }
      await rektContract.mintWithID(
        imageTestContract.address,
        1,
        "Rekt in Peace Orange"
        ,overrides
      )

      expect(await rektContract._tokenIds()).to.equal(1)
      expect(await rektContract.tokenURI(0)).to.equal(baseURL+"0");
    })
  })
})