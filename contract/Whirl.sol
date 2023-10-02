import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./HungTie.sol"

abstract contract Whirl is ReentrancyGuard {

    struct Auction {
        bool hasBid
        bytes32 commitment
        Bid bid
    }

    struct Bid {
        bytes32 paymentCommitment
        bytes32 priceCommitment
    }

    struct EnoughPayload {
        bytes proof
        bytes32 root
    }

    event Auction(bytes32 indexed commitment, bytes32 id, uint256 timestamp);

    mapping(bytes32 => Auction) public _auctions;

    function auction(
        bytes32 _commitment
    ) external nonReentrant virtual;

    function bid(
        bytes32 _id,
        bytes calldata _proof,
        bytes32 _root,
        bytes32 _commitment
    ) external payable nonReentrant virtual;
    // calls own.verify(_proof, _root, _commitment, _auctions[_id].secretCommitment);

    function slash(
        bytes32 _id,
        bytes calldata _proof,
        bytes32 priceCommitment
        EnoughPayload _enough
    ) external nonReentrant virtual;
    // calls price.verify(_proof, _auction[_id].commitment, priceCommitment);
    // calls enough.verify(_enough.proof, _enough.root, _auction[_id].bid.paymentCommitment, priceCommitment, false);

    function withdraw(
        bytes32 _id,
        bytes   calldata _proof,
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _refund
    ) external payable nonReentrant virtual;
}
