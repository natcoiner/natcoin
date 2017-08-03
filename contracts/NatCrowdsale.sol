pragma solidity ^0.4.11;

import './NatCoin.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';


contract NatCoinCrowdsale is Crowdsale, Ownable {

  uint256 public icoSupply;
  uint256 public reserveSupply;
  uint256 public paymentSupply;
  uint256 public coreSupply;
  uint256 public reveralSupply;

  uint256 public usedIcoSupply;
  uint256 public usedReserveSupply;
  uint256 public usedPaymentSupply;
  uint256 public usedCoreSupply;
  uint256 public usedReveralSupply;

  function getIcoSupply() public returns(uint256) { return icoSupply; }
  function getReserveSupply() public returns(uint256) { return reserveSupply; }
  function getPaymentSupply() public returns(uint256) { return paymentSupply; }
  function getCoreSupply() public returns(uint256) { return coreSupply; }
  function getReveralSupply() public returns(uint256) { return reveralSupply; }

  function getUsedReserveSupply() public returns(uint256) { return usedReserveSupply; }
  function getUsedPaymentSupply() public returns(uint256) { return usedPaymentSupply; }
  function getUsedCoreSupply() public returns(uint256) { return usedCoreSupply; }
  function getUsedReveralSupply() public returns(uint256) { return usedReveralSupply; }

  NatCoin natcoinTokenContract;

  function NatCoinCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) Crowdsale(_startBlock, _endBlock, _rate, _wallet) {
    icoSupply =      5000000 * 10**18;
    reserveSupply =  8000000 * 10**18;
    paymentSupply = 11000000 * 10**18;
    coreSupply =    10500000 * 10**18;
    reveralSupply =   500000 * 10**18;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    return new NatCoin();
  }

  function claimReservedTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > reserveSupply - usedReserveSupply) throw;
    token.mint(_to, _amount);
    reserveSupply += _amount;
  }

  function claimPaymentTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > paymentSupply - usedPaymentSupply) throw;
    token.mint(_to, _amount);
    paymentSupply += _amount;
  }

  function claimCoreTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > coreSupply - usedCoreSupply) throw;
    natcoinTokenContract.mint(_to, _amount);
    coreSupply += _amount;
  }

  function claimReveralTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > reveralSupply - reveralCoreSupply) throw;
    natcoinTokenContract.mint(_to, _amount);
    reveralSupply += _amount;
  }

}
