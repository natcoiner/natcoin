var NatCoinCrowdsale = artifacts.require("./NatCoinCrowdsale.sol")

module.exports = function(deployer, network, accounts) {
  const startBlock = web3.eth.blockNumber + 2 // blockchain block number where the crowdsale will commence. Here I just taking the current block that the contract and setting that the crowdsale starts two block after
  const endBlock = startBlock + 300  // blockchain block number where it will end. 300 is little over an hour.
  const rate = new web3.BigNumber(300) // rate of ether to Nat Coin in wei 1 NatCoin = 10 Wei
  const wallet = '0x06E11F1E94e054CB85dFE3010106226a27E44B88' // the address that will hold the fund. Recommended to use a multisig one for security.

  deployer.deploy(NatCoinCrowdsale, startBlock, endBlock, rate, wallet)
}

