import "./Tornado.sol";

interface ICommitmentVerifier {
  function verifyProof(bytes memory _proof, uint256[3] memory _input) external returns (bool);
}

abstract contract HungTie is Tornado {

  ICommitmentVerifier public immutable collectVerifier;
  ICommitmentVerifier public immutable ownerVerifier;
  ICommitmentVerifier public immutable enoughVerifier;

  event Collect(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);

  function collect(
    bytes calldata _proof,
    bytes32 _root,
    bytes32[32] _nullifierHash,
    bytes32 _commitment
  ) external nonReentrant {
    collectVerfifier.verifyProof(_proof, _root, _commitment, msg.sender);
  }

  function enough(
    bytes calldata _proof,
    bytes32 _root,
    bytes32 _commitment,
    bytes32 _thresholdCommitment,
    bool    _isEnough
  ) external nonReentrant virtual returns(bool);
}
