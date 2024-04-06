// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from 'forge-std/Script.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {LendingPool, ILendingPoolAddressesProvider} from 'src/contracts/protocol/lendingpool/LendingPool.sol';

//  command: make deploy-ledger contract=scripts/Deploy.s.sol:Deploy chain=mainnet
contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    LendingPool pool = new LendingPool();
    pool.initialize(ILendingPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER)));
    vm.stopBroadcast();
  }
}
