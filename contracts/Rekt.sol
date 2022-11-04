// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
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

    uint private _price;
    string private _baseURL;
    
    Counters.Counter private _tokenIds;
    mapping(uint256 => RektDetails) private _metadata;
    event Mint(address sender, uint256 tokenId, RektDetails rektDetails);

    constructor(string memory baseURL) ERC721("Rekt in Peace", "REKT") {
        _price = 0.02 ether;
        _baseURL = baseURL;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURL;
    }

    function mintWithID(
        address rektContract,
        uint256 rektId,
        string calldata rektMessage
    ) public payable {
        require(msg.value >= 10, "Not enough ETH sent; check price!"); 
        checkOwnership(rektContract, rektId);
        uint256 tokenId = _tokenIds.current();
        _safeMint(_msgSender(), tokenId);
        RektDetails memory details = RektDetails(rektContract, rektId, rektMessage);
        _metadata[tokenId] = details;
        _tokenIds.increment();
        emit Mint(msg.sender, tokenId, details);
    }

    function checkOwnership(address rektContract, uint256 rektId) internal view {
        if ( ERC165Checker.supportsInterface(rektContract, type(IERC721).interfaceId)) {
            IERC721 checkContract = IERC721(rektContract);
            require(msg.sender == checkContract.ownerOf(rektId), "This address does not own the ERC721 proposed");
        } else if (ERC165Checker.supportsInterface(rektContract, type(IERC1155).interfaceId)) {
            IERC1155 checkContract = IERC1155(rektContract);
            require(checkContract.balanceOf(msg.sender, rektId) > 0, "This address does not own the ERC1155 proposed");
        } else {
            revert("The adress proposed is not an ERC721 or ERC1155");
        }
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{
            value: address(this).balance
            }("");
        require(success, "Withdrawal failed");
    }

    function price() public view returns (uint) {
        return _price;
    }

    function totalMinted() public view returns (uint256) {
        return _tokenIds.current();
    }

    function setPrice(uint newPrice) public onlyOwner nonReentrant {
        _price = newPrice;
    }

    function rektData(uint256 tokenId) public view {
        _requireMinted(tokenId);
    }
}