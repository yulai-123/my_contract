// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import './IERC165.sol';
import './IERC1155.sol';
import './IERC1155Errors.sol';
import './IERC1155TokenReceiver.sol';

contract ERC1155 is IERC165, IERC1155, IERC1155Errors {
    mapping(uint256 => mapping(address => uint256)) private balances;
    mapping(address _operator => mapping (address _approved => bool)) private approvaledForAll;

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(IERC165).interfaceId ||
            interfaceID == type(IERC1155).interfaceId;
    }

    function mint(address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
        if (_to == address(0)) {
            revert AddressInvalid();
        }
        if (balances[_id][_to] + _value < 0) {
            revert ArithmeticOverflow();
        }
        
        balances[_id][_to] += _value;

        emit TransferSingle(msg.sender, address(0), _to, _id, _value);

        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            bytes4 result = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, address(0), _id, _value, _data);

            if (result != IERC1155TokenReceiver(_to).onERC1155Received.selector) {
                revert CallFailed();
            }
        }
    }

    function _update(address _from, address _to, uint256 _id, uint256 _value) internal {
        if (balances[_id][_from] < _value) {
            revert QuantityTooLarge();
        }
        if (balances[_id][_to] + _value < 0) {
            revert ArithmeticOverflow();
        }

        balances[_id][_from] -= _value;
        balances[_id][_to] += _value;
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
        if (msg.sender != _from && !approvaledForAll[_from][msg.sender]) {
            revert MissAuth();
        }
        if (_to == address(0)) {
            revert AddressInvalid();
        }
        
        _update(_from, _to, _id, _value);

        emit TransferSingle(msg.sender, _from, _to, _id, _value);

        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            bytes4 result = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _value, _data);

            if (result != IERC1155TokenReceiver(_to).onERC1155Received.selector) {
                revert CallFailed();
            }
        }
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
        if (msg.sender != _from && !approvaledForAll[_from][msg.sender]) {
            revert MissAuth();
        }
        if (_to == address(0)) {
            revert AddressInvalid();
        }

        if (_ids.length != _values.length) {
            revert ParamInvalid();
        }

        for (uint256 i = 0; i < _ids.length; i++) {
            _update(_from, _to, _ids[i], _values[i]);
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _values);

        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        if (size > 0) {
            bytes4 result = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _values, _data);

            if (result != IERC1155TokenReceiver(_to).onERC1155BatchReceived.selector) {
                revert CallFailed();
            }
        }
    }

    function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
        return balances[_id][_owner];
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
        if (_owners.length != _ids.length) {
            revert ParamInvalid();
        }
        
        uint256[] memory result = new uint256[](_owners.length);

        for (uint256 i = 0; i < _owners.length; i++) {
            result[i] = balances[_ids[i]][_owners[i]];
        }

        return result;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        approvaledForAll[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return approvaledForAll[_owner][_operator];
    }
}