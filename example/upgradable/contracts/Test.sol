// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test {

    event StoreWords(address addr);
    event StoreA(uint256 a);

    address private words;
    uint256 public a;

    function storeA(uint256 a_) external payable {
        a = a_;
        emit StoreA(a);
    }

    function storeWords(address words_) external payable {
        words = words_;
        emit StoreWords(words);
    }

    function getWords() external view returns (address) {
        return words;
    }
}

