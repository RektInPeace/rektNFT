import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Rekt, ImageTest, Rekt__factory, ImageTest__factory } from "../../frontend/src/typchain-types/";
import { Signer } from "ethers";



describe("Rekt", function () {
  let rektContract: Rekt
  let imageTestContract:ImageTest
  let owner: Signer, addr1, addr2, addr3, addrs
  let ImageTest, Rekt

  beforeEach(async function() {
    ImageTest = await ethers.getContractFactory("ImageTest") as ImageTest__factory
    imageTestContract = await ImageTest.deploy()
    Rekt = await ethers.getContractFactory("Rekt") as Rekt__factory
    
    rektContract = await Rekt.deploy()
    ;[owner, addr1, addr2, addr3] = await ethers.getSigners()

  })

  describe("Deployment", async function () {
    it("Should set the right owner", async function () {
      const _owner = await rektContract.owner()
      expect(_owner).to.equal(await owner.getAddress());
    });
    it("Should set the right mint price", async function () {
      const price = await rektContract.mintPrice() // 
      const priceString = ethers.utils.formatEther(price);
      expect(priceString).to.equal("0.2")
    })
  })

  describe("Mint", async function () {

    it("Should Mint Square NFT", async function() {
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(1)   
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(2)   
      await imageTestContract.mint()
      expect(await imageTestContract._tokenIds()).to.equal(3)   
    })

     it("Should Mint Rekt NFT", async function () {
      await imageTestContract.mint()
      const overrides = {
        value: ethers.utils.parseEther('0.02'),
      }
      await rektContract.mintWithID(
        imageTestContract.address,
        1,
        "Orange Color",
        "https://ipfs.io/ipfs/QmbViGww8GWBHc1RnM4RgSCKavU1Ukh87X4dYFG9zhD9cY",
        "Rekt in Peace Orange"
        ,overrides
      )
      const contractNames = await rektContract.contractNames(imageTestContract.address, 1)
      const names: [string, string] = ['ImageTest','IMGT']
      expect(contractNames[0]).to.equal(names[0])
      expect(contractNames[1]).to.equal(names[1])
      expect(await rektContract._tokenIds()).to.equal(1)
      // console.log(await rektContract.tokenURI(1));
      console.log(await imageTestContract.tokenURI(1));

    })
  })
})



    // describe("Contract Names", function() {
    //   it("Should Succesfully Return Contract Names", async function () {
    //     // expect(await rekt.contractNames(
    //     //   square.address,
    //     //   1,
    //     // ) as string[]).to.equal(['ColorSquare', 'CLRS']);
    //     console.log(await rekt.contractNames(
    //       square.address,
    //       1,
    //     ));
    //   })
    // });
    // describe("Mint Rekt with MetaHome", function() {
    //   it("Should Succesfully Rekt NFT", async function () {
    //     const rifigy = await ethers.getImpersonatedSigner("0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0");

    //     const Rekt = await ethers.getContractFactory("Rekt", rifigy);
    //     const rekt2 = await Rekt.deploy();
    //     await rekt2.mintWithID(
    //       '0x3872beeb0edef42f39e3b8e7d5339352f22d319a',
    //       124,
    //       "MetaHome 124",
    //       "https://ipfs.io/ipfs/bafybeifp3ltr2u6ng4nxansqczxqvspjlhsoll4n6eqtzioyas5g6m2psm/MO_7/MO_7_H.jpg",
    //       "Rekt in Peace My MetaHome"
    //     )
    //     expect(await rekt._tokenIds()).to.equal(2);
    //     console.log(await rekt.tokenURI(2));
    //   })
    // });
  // })




// describe("Rekt", function () {
//   async function deployFixture() {
//     // Contracts are deployed using the first signer/account by default
//     const [owner, otherAccount] = await ethers.getSigners();

//     const Square = await ethers.getContractFactory("ColorSquare");
//     const square = await Square.deploy();

//     const Rekt = await ethers.getContractFactory("Rekt");
//     const rekt = await Rekt.deploy();

//     return { rekt, square, owner, otherAccount };
//   }

//   let Rekt, rektContract, owner, addr1, addr2, addr3, addrs
  

//   describe("Deployment", async function () {
//     const { rekt, owner } = await loadFixture(deployFixture);
//     it("Should set the right owner", async function () {
//       expect(await rekt.owner()).to.equal(owner.address);
//     });
//     it("Should set the right mint price", async function () {
//       console.log(await rekt.mintPrice())
//       // expect((await rekt.mintPrice() as ethers.BigNumber).toNumber()).to.equal(200000000000000000);
//     });
//   });

//   describe("Mint", async function () {
//     const { square, rekt } = await loadFixture(deployFixture);

//     describe("Mint Square", function() {
//       it("Should Succesfully Mint Square", async function () {
//         await square.mintWithColor("red")
//         expect(await square._tokenIds()).to.equal(1);
//       })
//     });
//     describe("Mint Rekt with Square", function() {
//       it("Should Succesfully Rekt NFT", async function () {
//         const overrides = {
//           value: ethers.utils.parseEther('0.02'),
//         }
//         await rekt.mintWithID(
//           square.address,
//           1,
//           "Color",
//           "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
//           "Rekt in Peace Color", 
//           overrides
//         )
//         expect(await rekt._tokenIds()).to.equal(1);
//         console.log(await rekt.tokenURI(1));
//       })
//     });

//   });

