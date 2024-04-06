// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {IERC20} from '../src/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {LendingPool} from '../src/contracts/protocol/lendingpool/LendingPool.sol';

/**
 * @dev Test for Ethereum payload
 * command: make test-contract filter=AaveV3Ethereum_SetPriceCapAdapters_20240227
 */
contract RateSwap is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19369113);
    vm.startPrank(0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A);
    LendingPool pool = new LendingPool();
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolImpl(address(pool));
    vm.stopPrank();
  }

  function getsDaiUsers() internal returns (address[] memory) {
    address[] memory users = new address[](5);
    users[0] = 0x1047DC58a642AEd18B1DC04C11f02C622b42cf21;
    users[1] = 0xeb7AE9d125442A5b4ed57FE7C4Cbc87512B02ADA;
    users[2] = 0xC28AC4b691cFd8d27B7e1c6fc757FE2cBa10604A;
    users[3] = 0xe59d885CEc9Fb8A79E4ee30EDabd250E470E757A;
    users[4] = 0x9CD6658537dDBB63F075ec3E92e53Ef3E723b195;

    return users;
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_swapRate() public {
    DataTypes.ReserveData memory reserveData = AaveV2Ethereum.POOL.getReserveData(
      0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    address[] memory users = getsDaiUsers();
    for (uint256 i = 0; i < users.length; i++) {
      uint256 stableDebtBefore = IERC20(reserveData.stableDebtTokenAddress).balanceOf(users[i]);
      uint256 variableDebtBefore = IERC20(reserveData.variableDebtTokenAddress).balanceOf(users[i]);

      LendingPool(address(AaveV2Ethereum.POOL)).swapToVariable(
        0x6B175474E89094C44Da98b954EedeAC495271d0F,
        users[i]
      );

      uint256 stableDebtAfter = IERC20(reserveData.stableDebtTokenAddress).balanceOf(users[i]);
      uint256 variableDebtAfter = IERC20(reserveData.variableDebtTokenAddress).balanceOf(users[i]);
      assertEq(stableDebtAfter, 0);
      assertApproxEqAbs(variableDebtAfter, variableDebtBefore + stableDebtBefore, 1);
    }
  }
}
