 // SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract DevNFT is ERC721Enumerable {
    // Initialize the ERC721 Contract
    constructor() ERC721(
        "Devs","D"
    ) {}

    // Add a public mint function to call the NFT
    function mint() public {
        _safeMint(msg.sender, totalSupply());
        }
}

