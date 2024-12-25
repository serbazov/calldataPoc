import { ethers } from "hardhat";
import { expect } from "chai";

describe("DataProcessor", function () {
  it("should process data and store helloWorld in storage", async () => {
    const dataProcessor = await ethers.deployContract("DataProcessor");
    const timestamp = Math.floor(Date.now() / 1000);
    const helloWorld = ethers.encodeBytes32String("helloWorld");

    const functionSelector =
      dataProcessor.interface.getFunction("processData").selector;
    const payload = ethers.concat([
      functionSelector,
      ethers.AbiCoder.defaultAbiCoder().encode(["uint256"], [timestamp]),
      helloWorld,
    ]);
    let signers = await ethers.getSigners();
    console.log(payload); // 0xdd0e34ef00000000000000000000000000000000000000000000000000000000676c19a668656c6c6f576f726c6400000000000000000000000000000000000000000000
    let tx = await signers[0].sendTransaction({
      to: dataProcessor!,
      data: payload,
    });
    let rec = await tx.wait();
    console.log("gasUsed", rec!.gasUsed);
    expect(await dataProcessor.storedData()).to.equal(helloWorld);
  });
  it("should process data Explicit and store helloWorld in storage", async () => {
    const dataProcessor = await ethers.deployContract("DataProcessor");
    const timestamp = Math.floor(Date.now() / 1000);
    const helloWorld = ethers.encodeBytes32String("helloWorld");

    const payload = ethers.concat([
      ethers.AbiCoder.defaultAbiCoder().encode(["uint256"], [timestamp]),
      helloWorld,
    ]);
    let signers = await ethers.getSigners();
    console.log(payload); // 0x00000000000000000000000000000000000000000000000000000000676c287768656c6c6f576f726c6400000000000000000000000000000000000000000000

    let tx = await dataProcessor
      .connect(signers[0])
      .processDataExplicit(payload);
    let rec = await tx.wait();
    console.log("gasUsed", rec!.gasUsed);
    expect(await dataProcessor.storedData()).to.equal(helloWorld);
  });
});
