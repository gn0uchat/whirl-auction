import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./HungTie.sol"

abstract contract Whirl is ReentrancyGuard {

    struct Auction {
        bool hashBid
        Bid latestBid
    }

    struct Bid {
        bytes32 paymentCommitment
        bytes32 priceCommitment
    }

    struct CollectPayload {
        bytes _proof,
        bytes32 _root,
        bytes32[16] _nullifierHash,
        bytes32 _commitment
    }

    struct EnoughPayload {
        bytes _proof,
        bytes32 _root,
        bytes32 _thresholdCommitment,
    }

    event Auction(bytes32 indexed commitment, bytes32 id, uint256 timestamp);

    mapping(bytes32 => Auction) public _auctions;

    function auction(
        bytes32 _commitment
    ) external nonReentrant virtual;

    function bid(
        bytes32 _auctionID,
        bytes32 _priceCommitment,
        CollectPayload _payment
    ) external payable nonReentrant virtual;

    function slash(
        bytes32 _auctionID,
        EnoughPayload _enough
    ) external nonReentrant virtual;

    function withdraw(
        bytes32 _auctionID,
        bytes   calldata _proof,
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _refund
    ) external payable nonReentrant virtual;
}
