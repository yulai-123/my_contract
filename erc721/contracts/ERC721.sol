// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import './IERC721.sol';
import './IERCMetadata.sol';
import './ERC721TokenReceiver.sol';
import './util/Strings.sol';

contract ERC721 is IERC721, IERC721Metadata {
    using Strings for string;
    using Strings for uint256;

    string private _name;
    string private _symbol;
    string private baseURI;

    mapping(address => uint256) balances;
    mapping(uint256 => address) owners;
    mapping(uint256 => address) grantees;
    mapping(address => mapping(address => bool)) approvalForAll;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(IERC721).interfaceId ||
            interfaceID == type(IERC721Metadata).interfaceId;
    }

    event Mint(address indexed owner, uint256 tokenId);

    function mint(address _owner, uint256 tokenId) external {
        require(!_requiredExist(tokenId), "token id exist");
        require(_owner != address(0), "owner can not be 0");
        require(balances[_owner] + 1 > 0, "mint failed");

        owners[tokenId] = _owner;
        balances[_owner]++;

        emit Mint(_owner, tokenId);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        _requiredExist(_tokenId);

        if (bytes(baseURI).length == 0) {
            return "";
        }

        return baseURI.concat(_tokenId.toString());
    }

    function setBaseURI(string memory uri) external payable {
        baseURI = uri;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "owner should not be 0");

        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        _requiredExist(_tokenId);

        return owners[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
        require(_requiredExist(_tokenId), "token id is not exist");
        require(_from == owners[_tokenId], "from must be sender");
        require(_checkAuthorized(_from, _tokenId), "from does not have auth");
        require(_to != address(0), "to should not be 0");

        grantees[_tokenId] = address(0);
        if (balances[_from] > 0) {
            balances[_from] -= 1;
        }
        if (balances[_to] + 1 > 0) {
            balances[_to] += 1;
        }
        owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public payable {
        transferFrom(_from, _to, _tokenId);
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        // _to 是一个合约地址
        if (size > 0) {
            // 目标需要实现 Receiver 接口
            bytes4 result = ERC721TokenReceiver(_to).onERC721Received(_to, _from, _tokenId, data);
            require(result == ERC721TokenReceiver(_to).onERC721Received.selector, "call _to failed");
        }
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    

    function approve(address _approved, uint256 _tokenId) external payable {
        require(owners[_tokenId] == msg.sender ||
            approvalForAll[owners[_tokenId]][msg.sender], "sender does not have auth");
        
        grantees[_tokenId] = _approved;

        emit Approval(owners[_tokenId], _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external payable {
        approvalForAll[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(_requiredExist(_tokenId), "tokenId is not exist");

        return grantees[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return approvalForAll[_owner][_operator];
    }

    function _checkAuthorized(address _from, uint256 tokenId) internal view returns (bool) {
        require(owners[tokenId] == _from, "owner is not from");
        if (owners[tokenId] == _from) {
            return true;
        }

        if (grantees[tokenId] == _from) {
            return true;
        }

        if (approvalForAll[owners[tokenId]][_from]) {
            return true;
        }

        return false;
    }

    function _requiredExist(uint256 _tokenId) internal view returns (bool) {
        return owners[_tokenId] != address(0);
    }
}