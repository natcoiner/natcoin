pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract NatCoin is MintableToken {
  string public name = "NATCOIN";
  string public symbol = "NTC";
  uint256 public decimals = 18;
}
