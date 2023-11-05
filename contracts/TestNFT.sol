// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TestNFT is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    event BaseURIChanged(string newBaseURI);

    string public baseURI;

    Counters.Counter public tokenIDCounter;

    constructor() ERC721("TEST Collection", "TEST") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string calldata newbaseURI) external onlyOwner {
        baseURI = newbaseURI;
        emit BaseURIChanged(newbaseURI);
    }

    function mint(address owner) public nonReentrant onlyOwner {
        tokenIDCounter.increment();

        uint256 tokenID = tokenIDCounter.current();

        _safeMint(owner, tokenID);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}