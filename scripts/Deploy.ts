import hre from "hardhat"

async function sleep(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

async function main() {
    // Deploy the NFT Contract
    const nftContract = await hre.ethers.deployContract("DevNFT");
    await nftContract.waitForDeployment();
    console.log("DevNFT deployed to : ", nftContract.target);

    // Deploy the fake NFT Market
    const myNFTMkt = await hre.ethers.deployContract("myNFTMkt");
    await myNFTMkt.waitForDeployment();
    console.log("myNFTMkt deployed to : ", myNFTMkt.target);

    // Deploy the DAO Contract
    const amount = hre.ethers.parseEther("2");
    const daoContract = await hre.ethers.deployContract("DevDAO", [
        myNFTMkt.target,
        nftContract.target,
        ], {value: amount,});
    await daoContract.waitForDeployment();
    console.log("DevDAO deployed to:", daoContract.target);

    // Sleep for 30 seconds to let Etherscan catch up with the deployments
    await sleep(30 * 1000);

    // Verify the NFT Contract
    await hre.run("verify:verify", {
        address: nftContract.target,
        constructorArguments: [],
    });

    // Verify the Fake Marketplace Contract
    await hre.run("verify:verify", {
        address: myNFTMkt.target,
        constructorArguments: [],
    });

    // Verify the DAO Contract
    await hre.run("verify:verify", {
        address: daoContract.target,
        constructorArguments: [
        myNFTMkt.target,
        nftContract.target,
        ],
    });

}

// Check and handle errors
main().catch((error)=>{
    console.log(error);
    process.exitCode = 1;
});