//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import './IERC1155TokenReceiver.sol';
import './IERC165.sol';

contract ERC1155TokenReceiver is IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(IERC165).interfaceId ||
            interfaceID == type(IERC1155TokenReceiver).interfaceId;
    }

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4) {
        if (_data.length == 0) {
            return "";
        }

        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4) {
        if (_data.length == 0) {
            return "";
        }

        return this.onERC1155BatchReceived.selector;
    }
}