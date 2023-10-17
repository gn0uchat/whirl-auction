import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./HungTie.sol"

abstract contract Whirl is ReentrancyGuard {

  HungTie public hungTie;

  struct Auction {
      bytes32 priceCommitment
      bytes32 speedCommitment
      bytes32 sellerSecretCommitment
      uint pausedDuration
      Bid bid
  }

  struct Bid {
      bytes32 paymentCommitment
      timestamp
      // bytes32 priceCommitment
  }

  struct EnoughPayload {
      bytes proof
      bytes32 root
  }

  event Auction(bytes32 indexed commitment, bytes32 id, uint256 timestamp);

  mapping(bytes32 => Auction) public _auctions;

  function hasBid(Auction auction) internal pure returns(bool){
    return auction.bid != 0;
  }

  function auction(
    bytes32 _priceCommitment
    bytes32 _speedCommitment,
    bytes32 _sellerSecretCommitment
  ) external nonReentrant virtual;

  function bid(
    bytes32 _id,
    bytes calldata _proof,
    bytes32 _root,
    bytes32 _commitment,
    bytes32 paymentCommitment
  ) external payable nonReentrant {

    Auction auction = auctions[_id];

    require(auction != 0);
    require(! hashBid(auction));

    hungTie.collect(_proof, _root, _auctions[_id].sellerSecretCommitment);
    _auctions[_id].bid = bid;
    _auctions[_id].timestamp = ;
  }

  function slash(
    bytes32 _id,
    bytes calldata _proof,
    bytes32 priceCommitment
    EnoughPayload _enough
  ) external nonReentrant {
    require(! hungTie.enough());
    // do slash ...
  }

  function withdraw(
    bytes32 _id,
    bytes   calldata _proof,
    address payable _recipient,
    address payable _relayer,
    uint256 _fee,
    uint256 _refund
  ) external payable nonReentrant {
    // withdraw if pass time limit ...
  }
}
