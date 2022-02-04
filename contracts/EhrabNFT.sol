// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "base64-sol/base64.sol";

// Inherit imported contract. Will have access to that contract's methods
contract EhrabNFT is ERC721URIStorage {
    // Utility from OpenZeppelin to keep track of tokenIds.
    using Counters for Counters.Counter;
    // Initialize contract state in contract storage
    Counters.Counter private _tokenIds;

		// State to expose to public, should be able to use _tokenIds?
		// REvisit
		uint256 public nftCount = 0;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Word arrays for generating random strings
    string[] firstWords = [
        "Fantastic",
        "Amazing",
        "Small",
        "Large",
        "Huge",
        "Wild"
    ];

    string[] secondWords = [
        "Phone",
        "Wheel",
        "Car",
        "Shoe",
        "Scooter",
        "Basket"
    ];

    string[] thirdWords = [
        "Apples",
        "Trees",
        "Hats",
        "Dummies",
        "Bananas",
        "Monkeys"
    ];

    // ----------- Events -----------
    // Events are messages the smart contracts throw out, we can capture on client side in real-time
    // Despite transaction being mined, its possible the NFT was NOT minted, there could have been an error
    event NewNFTMinted(address sender, uint256 tokenId);

    // We need to set the name of our NFTs token and its symbol
    constructor() ERC721("EhrabM", "EH") {
        console.log("Welcome to Ehrab's collection.");
    }

    // I create a function to randomly pick a word from each array.
    // Put string into memory to persist through other function calls
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // Seed the random generator, the passed string is used to create the source of randomness
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    // Takes two arguments, combines them, resulting string to be used as a source of randomness
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // Function for user to hit to get their NFT
    function mintEhrabNFT() public {
				// ------------- ADD REQUIRE STATEMENT -------------

				// ------------- ADD REQUIRE STATEMENT -------------

        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        // Combine the strings, in this case, abi.encodePacked() is concatinating the strings
        string memory combined = string(abi.encodePacked(first, second, third));

        // I concatenate it all together, and then close the <text> and <svg> tags.
        // Log stringified SVG to the console. This can be then viewed in an SVG viewer.
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combined, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it using imported libarary.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combined,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log("URi: \n");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        // ------------------------------------------------ Transactions for mint and setting metadata ------------------------------------------------

        // Actually mint the NFT to the sender using msg.sender passing tokenId as argument
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data. Pass tokenId, and NFT metadata in JSON format (finalTokenUri), link to resource.
        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

				// Update public contract state variable
				nftCount = newItemId;

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        // Emit minting event
        emit NewNFTMinted(msg.sender, newItemId);
    }

}
