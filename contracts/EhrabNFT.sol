// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


// Inherit imported contract. Will have access to that contract's methods
contract EhrabNFT is ERC721URIStorage {
	// Utility from OpenZeppelin to keep track of tokenIds.
	using Counters for Counters.Counter;
	// Initialize contract state in contract storage
	Counters.Counter private _tokenIds;
	
	// We need to set the name of our NFTs token and its symbol
	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("Welcome to Ehrab's collection.");
	}

	// Function for user to hit to get theri NFT
	function mintEhrabNFT() public {
		// Get the current tokenId, this starts at 0.
		uint256 newItemId = _tokenIds.current();

		// Actually mint the NFT to the sender using msg.sender passing tokenId as argument
		_safeMint(msg.sender, newItemId);

		// Set the NFTs data. Pass tokenId, and NFT metadata in JSON format, link to resource.
		_setTokenURI(newItemId, "https://jsonkeeper.com/b/WJWZ");
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		// Increment the counter for when the next NFT is minted.
		_tokenIds.increment();
	}





}