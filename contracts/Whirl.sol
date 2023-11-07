// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./HungTie.sol";

contract Whirl is ReentrancyGuard {

  HungTie public hungTie;
  IERC721 internal nft;

  struct Auction {
      bytes32 priceCommitment;        // hash(init_price | secret)
      bytes32 speedCommitment;        // hash(dec_speed | secret)
      bytes32 paymentSecretCommitment;// hash(secret)
      uint256 initBlockNumber;
      uint256 pausedDuration;         // blocks
      Bid bid;
  }

  struct Bid {
      bytes32 paymentCommitment;
      uint256 blockNumber;
  }

  struct EnoughPayload {
      bytes proof;
      bytes32 root;
      bytes32 commitment;
      bytes32 thresholdCommitment;
  }

  event CreateAuction(bytes32 indexed commitment, bytes32 id, uint256 timestamp);

  mapping(bytes32 => Auction) public _auctions;

  constructor(
    address nftAddress
  ) {
    nft = IERC721(nftAddress);
  }

  function hasBid(Auction memory _auction) internal pure returns(bool) {
    return _auction.bid.blockNumber != 0;
  }

  function createAuction(
    bytes32 _id,
    bytes32 _priceCommitment,
    bytes32 _speedCommitment,
    bytes32 _sellerSecretCommitment,
    uint256 pausedDuration
  ) external nonReentrant returns(bytes32) {
    Bid memory _bid = Bid(0x0, 0);
    Auction memory _auction = Auction(_priceCommitment, _speedCommitment, _sellerSecretCommitment, block.number, pausedDuration, _bid);
    _auctions[_id] = _auction;

    emit CreateAuction(_sellerSecretCommitment, _id, block.timestamp);
    return _id;
  }

  function bid(
    bytes32 _id,
    bytes32 paymentSecretCommitment
  ) external payable nonReentrant {

    Auction storage _auction = _auctions[_id];

    require(! hasBid(_auction));

    Bid  memory _bid = Bid(paymentSecretCommitment, block.number);
    _auction.bid = _bid;
  }

  function slash(
    bytes32 _id,
    EnoughPayload calldata _enough
  ) external nonReentrant {
    Auction storage _auction = _auctions[_id];
    require(! hungTie.enough(_enough.proof, _enough.root, _enough.commitment, _enough.thresholdCommitment));
    _auction.bid = Bid(0x0, 0);
    // do slash ...
  }

  function withdraw(
    bytes32 _id,
    uint256 nftId,
    bytes   calldata _proof,
    address payable _recipient,
    address payable _relayer,
    uint256 _fee,
    uint256 _refund
  ) external payable nonReentrant {
    Auction memory _auction = _auctions[_id];
    require(_auction.bid.blockNumber != 0);
    require(block.number >= _auction.bid.blockNumber + _auction.pausedDuration);
    nft.safeTransferFrom(address(this), msg.sender, nftId);
  }
}
