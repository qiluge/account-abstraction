import {EntryPoint__factory, SimpleAccountFactory__factory} from '../typechain'
import {ethers} from "hardhat";

async function deployBsctest() {
    const [signer] = await ethers.getSigners()
    const entryPoint = await new EntryPoint__factory(signer).deploy()
    await entryPoint.deployed()
    const simpleAccFactory = await new SimpleAccountFactory__factory(signer).deploy(entryPoint.address)
    console.log('entry point: %s, account factory: %s', entryPoint.address, simpleAccFactory.address)
}

deployBsctest().then()
