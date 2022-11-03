// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol"; 

contract ImageTest is ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter public _tokenIds;

    constructor() ERC721("ImageTest", "IMGT"){ 
        mint();
    }

    function mint() 
    public {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(msg.sender, tokenId);
        setTokenURI(tokenId);
    }

    function setTokenURI(uint256 tokenId) internal {
        string memory url = 'https://rektinpeace.herokuapp.com/test/0x885525B82e8ab86c5f463Cef0a4b19a43EF005c5/2311/1';
        _setTokenURI(tokenId, url);
    }
}