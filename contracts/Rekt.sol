// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Rekt is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    struct RektDetails {
        address rektAddress;
        uint256 rektId;
        string message;
    }

    uint public price;
    string public baseURL;
    
    Counters.Counter public _tokenIds;
    mapping(uint256 => RektDetails) public _metadata;
    event Mint(address sender, uint256 tokenId, RektDetails rektDetails);


    constructor(string memory _baseURL) ERC721("Rekt in Peace", "REKT") {
        price = 0.02 ether;
        baseURL = _baseURL;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURL;
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
        RektDetails memory details = RektDetails(_rektContract, _rektId, _rektMessage);
        _metadata[tokenId] = details;
        _tokenIds.increment();
        emit Mint(msg.sender, tokenId, details);
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    function setPrice(uint _price) public onlyOwner nonReentrant {
        price = _price;
    }
}