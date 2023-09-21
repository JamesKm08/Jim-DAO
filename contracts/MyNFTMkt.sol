 // SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MYNFTMkt{
    // map an id to the address
    mapping (uint256 => address) public tokens;
    //set the NFT price
    uint256 nftPrice = 0.01 ether;

    // Ensure the caller address is the owner of the token
    function purchase(uint256 _tokenId) external payable{
        require(msg.value == nftPrice, "This NFT costs 0.01 Ether");
        tokens[_tokenId] = msg.sender;
    }

    // Return the price of the NFT
    function getPrice() external view returns(uint256){
        return nftPrice;
    }

    // Check whether the tokenId has already been sold
    function nftAvailability(uint256 _tokenId) external view returns(bool){
        if(tokens[_tokenId] == address(0)){
            return true;
            }
            return false;
    }

}