// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// pragma abicoder v2;

import * as Stu from "./Stu.sol";

contract Test {
  // 获取 Stu.sol 中的元素A
  function getImportedA() public pure returns (uint256) {
    return Stu.A;
  }
}

