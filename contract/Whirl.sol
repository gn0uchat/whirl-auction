import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./HungTie.sol"

abstract contract Whirl is ReentrancyGuard {

    struct Auction {
        bool isBid
        uint32 paymentLeafIndex
        bytes32 commitment
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
        bytes32 _commitment
    }

    event Auction(bytes32 indexed commitment, uint32 id, uint256 timestamp);

    mapping(uint32 => Auction) public _auctions;

    function auction(
        bytes32 _commitment
    ) external nonReentrant virtual;

    function bid(
        bytes calldata _proof,
        bytes _commitment,
        bytes32 nullifierHash,
        CollectPayload payment
    ) external payable nonReentrant virtual;

    function collect(
        bytes calldata _proof,
        bytes32 _root,
        bytes32[16] _nullifierHash,
        bytes32 _commitment
    ) external nonReentrant virtual;

    function slash(
        bytes calldata _proof,
        bytes32 nullifierHash,
        bytes32 _commitment,
        EnoughPayload payload
    ) external nonReentrant virtual;
}
