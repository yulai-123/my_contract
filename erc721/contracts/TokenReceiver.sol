// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import './ERC721TokenReceiver.sol';

contract TokenReceiver is ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external pure returns(bytes4) {
        if (_data.length > 0) {
            return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
        }

        return "";
    }
}