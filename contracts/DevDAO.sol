 // SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

//interface for the nft market
interface IMyNFTMkt{
    
    function getPrice() external view returns(uint256);
    function nftAvailability(uint256 _tokenId) external view returns(bool);
    function purchase(uint256 _tokenId) external payable;

}
//interface for the nft contract
interface IDevNFT{

    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external view returns (uint256);

}


contract DevDAO is Ownable {

    //create struct to contain the variables for the proposals
    struct Proposal{
        uint256 nftTokenId;
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;

        mapping(uint256 => bool) voters;
    }

    // Create a mapping of ID to Proposal
    mapping(uint256 => Proposal) public proposals;
    // Number of proposals that have been created
    uint256 public numProposals;

    //Create variables to store the contracts
    IMyNFTMkt myNFTMkt;
    IDevNFT myDevNFT;

    //Create a payable constructor to ensure we have a pool of ETH at the start
    //The constructor also initializes the contract instances
    constructor(address _myNFTMkt, address _myDevNFT) payable{
        myNFTMkt = IMyNFTMkt(_myNFTMkt);
        myDevNFT = IDevNFT(_myDevNFT);
    }

    // Create a modifier which only allows a function to be
    // called by someone who owns at least 1 NFT
    modifier nftHolderOnly() {
        require(myDevNFT.balanceOf(msg.sender) > 0, "You are NOT a DAO Member");
        _;
    }

    //Create a proposal which will check if the nft is available for sale
    function createProposal(uint256 _tokenId) external nftHolderOnly returns(uint256) {
        require(myNFTMkt.nftAvailability(_tokenId), "This NFT is NOT for Sale");
        Proposal storage proposal = proposals[numProposals];
        //Set the deadline for the proposal's voting
        proposal.deadline = block.timestamp + 5 minutes;

        numProposals++;
        return numProposals -1;
    }

}
