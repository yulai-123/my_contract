// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

library Strings {
    function concat(string memory current, string memory other) internal pure returns (string memory) {
        bytes memory cb = bytes(current);
        bytes memory ob = bytes(other);

        bytes memory result = new bytes(cb.length + ob.length);

        for (uint i = 0; i < cb.length; i++) {
            result[i] = cb[i];
        }

        for (uint i = 0; i < ob.length; i++) {
            result[cb.length+i] = ob[i];
        }
        
        return string(result);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint count = 0;
        uint reValue = value;
        while(reValue > 0) {
            reValue /= 10;
            count++;
        }

        bytes memory result = new bytes(count);

        for (uint i = count - 1; i >= 0; i--) {
            uint256 last = value % 10;
            result[i] = bytes1(uint8(48+last)); 
            value /= 10;
        }

        return string(result);
    }
}