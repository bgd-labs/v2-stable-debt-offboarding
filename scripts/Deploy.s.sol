// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from 'forge-std/Script.sol';
import {LendingPool} from 'src/contracts/protocol/lendingpool/LendingPool.sol';

//  command: make deploy-ledger contract=scripts/Deploy.s.sol:Deploy chain=mainnet
contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    new LendingPool();
    vm.stopBroadcast();
  }
}
