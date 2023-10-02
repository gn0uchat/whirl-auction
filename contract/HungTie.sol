import "./Tornado.sol";

abstract contract HungTie is Tornado {
  event Collect(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

  function collect(
    bytes calldata _proof,
    bytes32 _root,
    bytes32[16] _nullifierHash,
    bytes32 _commitment
  ) external nonReentrant virtual;

  function enough(
    bytes calldata _proof,
    bytes32 _root,
    bytes32 _commitment
  ) external pure nonReentrant virtual;
}
