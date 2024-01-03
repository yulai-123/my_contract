// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AirDrop is ERC20 {
    event AirDropEvent(address indexed to, uint256 value);

    mapping(address => bool) airDropMap;
    address owner;

    constructor() ERC20("tt", "tt") {
        owner = msg.sender;
        _mint(msg.sender, 100000000);
    }

    function airDrop() external payable {
        require(!airDropMap[msg.sender], "user has got air drop");

        airDropMap[msg.sender] = true;
        _transfer(owner, msg.sender, 1000);
        
        emit AirDropEvent(msg.sender, 1000);
    }
}