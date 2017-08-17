pragma solidity ^0.4.11;

import './NatCoin.sol';

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end block, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // start and end block where investments are allowed (both inclusive)
  uint256 public startBlock;
  uint256 public endBlock;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
    require(_startBlock >= block.number);
    require(_endBlock >= _startBlock);
    require(_rate > 0);
    require(_wallet != 0x0);

    token = createTokenContract();
    startBlock = _startBlock;
    endBlock = _endBlock;
    rate = _rate;
    wallet = _wallet;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal returns (MintableToken) {
    return new MintableToken();
  }


  // fallback function can be used to buy tokens
  function () payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal constant returns (bool) {
    uint256 current = block.number;
    bool withinPeriod = current >= startBlock && current <= endBlock;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return block.number > endBlock;
  }


}


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
    icoSupply =      5000000 * 10**17;
    reserveSupply =  8000000 * 10**17;
    paymentSupply = 11000000 * 10**17;
    coreSupply =    10500000 * 10**17;
    reveralSupply =   500000 * 10**17;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    return new NatCoin();
  }

  function claimReservedTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > reserveSupply - usedReserveSupply) revert();
    token.mint(_to, _amount);
    reserveSupply += _amount;
  }

  function claimPaymentTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > paymentSupply - usedPaymentSupply) revert();
    token.mint(_to, _amount);
    paymentSupply += _amount;
  }

  function claimCoreTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > coreSupply - usedCoreSupply) revert();
    natcoinTokenContract.mint(_to, _amount);
    coreSupply += _amount;
  }

  function claimReveralTokens(address _to, uint256 _amount) payable onlyOwner {
    if (_amount > reveralSupply - usedReveralSupply) revert();
    natcoinTokenContract.mint(_to, _amount);
    reveralSupply += _amount;
  }

}
