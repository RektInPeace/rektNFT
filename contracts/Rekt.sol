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

contract Rekt is ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Strings for address;
    using Strings for uint;

    struct RektDetails {
        address rektAddress;
        uint256 rektId;
        string message;

    }

    address public owner;
    uint public mintPrice;
    Counters.Counter public _tokenIds;
    string public baseURL;
    mapping(uint256 => RektDetails) public _metadata;



    constructor(string memory _baseURL) ERC721("Rekt in Peace", "REKT") {
        owner = msg.sender;
        mintPrice = 0.02 ether;
        baseURL = _baseURL;
    }

    function mintWithID(
        address _rektContract,
        uint256 _rektId,
        string memory _rektMessage
    ) public payable {
        require(msg.value >= 10, "Not enough ETH sent; check price!"); 
        checkOwnership(_rektContract, _rektId);

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _safeMint(_msgSender(), tokenId);
        RektDetails memory details = RektDetails(_rektContract, _rektId, _rektMessage);
        setTokenURI(tokenId, details);
    }


    function checkOwnership(
        address _contractAddress,
        uint256 _rektId
    ) internal virtual {
        IERC721 rektContract = IERC721(_contractAddress);
        require(msg.sender == rektContract.ownerOf(_rektId), 
            "This address does not own the NFT proposed"
        );
    }

    function setTokenURI(uint256 tokenId, RektDetails memory details) internal virtual {
        string memory url = string.concat(baseURL, tokenId.toString());
        _metadata[tokenId] = details;
        _setTokenURI(tokenId, url);
    }
}

    // struct RektData {
    //     address rektAddress;
    //     string contractName;
    //     string rektSymbol;
    //     uint256 rektId;
    //     string message;
    //     string name;
    //     string imgUrl;
    // }


    // function contractNames(
    //     address _contractAddress,
    //     uint256 _rektId
    // ) public view returns (string memory, string memory) {
    //     IERC721 rektContract = IERC721(_contractAddress);
    //     require(msg.sender == rektContract.ownerOf(_rektId), 
    //         "This address does not own the NFT proposed"
    //     );
    //     if (ERC165Checker.supportsInterface(_contractAddress, type(IERC721).interfaceId) ) {
    //         IERC721Metadata rektMetadata = IERC721Metadata(_contractAddress);
    //         return(rektMetadata.name(), rektMetadata.symbol());
    //     } else {
    //         return("Rekt", "REKT");
    //     }

    // } 

    // function _imageURI(RektData memory _rektData, string memory blockString) internal pure returns (string memory) {
    //     string memory svg = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" width="5000" height="5000" viewBox="0 0 5000 5000"><image href="https://i.ibb.co/SdLQtZd/Source-File-2-copy.png" height="5000" width="5000"/><text font-size="200pt" x="50%" y="35.5%" text-anchor="middle">',
    //     _rektData.contractName,
    //     '</text><text font-size="180" x="50%" y="73%" text-anchor="middle">',
    //     _rektData.message,
    //     '</text><text font-size="300" x="50%" y="87%" text-anchor="middle">#',
    //     _rektData.rektId.toString(),
    //     '</text><rect width="1100" height="1100" x="50%" y="55%" transform="translate(-550 -550)" fill="brown"/><rect width="1024" height="1024" x="50%" y="55%" transform="translate(-512 -512)" fill="#fff"/><image href="',
    //     _rektData.imgUrl,
    //     '" width="1024" height="1024" x="50%" y="55%" transform="translate(-512 -512)"/></svg>'));
    //     return string(abi.encodePacked(
    //         'data:image/svg+xml;base64,',
    //         Base64.encode(bytes(svg))
    //     ));
    // }

    //     function setTokenURI(
    //     uint256 tokenId, 
    //     RektData memory _rektData
    // ) internal {
    //     string memory attributes = string(abi.encodePacked(
    //         '[',
    //         '{"trait_type":"Rekt Contract","value":"',_rektData.rektAddress.toHexString(),'"},',
    //         '{"trait_type":"Rekt Token ID","value":"',_rektData.rektId.toString(),'"},',
    //         '{"trait_type":"RIP","value":"',_rektData.message,'"}',
    //         ']'
    //         ));
    //     string memory imageURI = _imageURI(_rektData, block.number.toString());
    //     // console.log(string(abi.encodePacked('Generate Metadata For ID: ', tokenId)));

    //     string memory uri = string(
    //         abi.encodePacked(
    //             "data:application/json;base64,",
    //             Base64.encode(
    //                 bytes(
    //                     abi.encodePacked(
    //                         '{"name":"RIP: ',_rektData.name,'",',
    //                         '"description":"Rekt in Peace: ',_rektData.message,'",',
    //                         '"attributes":',attributes,',',
    //                         // '"image":"',imageURI,'",',
    //                         '"image_data":"',imageURI,'",',
    //                         '"tokenId":',tokenId.toString(),'',
    //                         '}'
    //                     )
    //                 )
    //             )
    //         )
    //     );
    //     // console.log(string(abi.encodePacked('URI: ', uri)));
    //     _setTokenURI(tokenId, uri);
    // }