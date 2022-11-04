// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol"; 
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Rekt is ERC721URIStorage, ReentrancyGuard {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct RektDetails {
        address rektAddress;
        uint256 rektId;
        string message;
    }

    address public owner;
    uint public mintPrice;
    
    Counters.Counter public _tokenIds;
    mapping(uint256 => RektDetails) public _metadata;
    event NewItem(address sender, uint256 tokenId, RektDetails rektDetails);
    string public baseURL;



    constructor(string memory _baseURL) ERC721("Rekt in Peace", "REKT") {
        owner = msg.sender;
        mintPrice = 0.02 ether;
        baseURL = _baseURL;
    }

    function mintWithID(
        address _rektContract,
        uint256 _rektId,
        string calldata _rektMessage
    ) public payable {
        require(msg.value >= 10, "Not enough ETH sent; check price!"); 
        IERC721 rektContract = IERC721(_rektContract);
        require(msg.sender == rektContract.ownerOf(_rektId), "This address does not own the NFT proposed");
        uint256 tokenId = _tokenIds.current();
        _safeMint(_msgSender(), tokenId);
        setTokenURI(tokenId, _rektContract, _rektId, _rektMessage);
        _tokenIds.increment();

    }

    function setTokenURI(
        uint256 tokenId, 
        address _rektContract,
        uint256 _rektId,
        string calldata _rektMessage
    ) internal virtual {
        string memory url = string.concat(baseURL, tokenId.toString());
        _metadata[tokenId] = RektDetails(_rektContract, _rektId, _rektMessage);
        _setTokenURI(tokenId, url);
    }
}