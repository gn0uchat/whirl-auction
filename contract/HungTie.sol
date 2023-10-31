// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MerkleTreeWithHistory.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface IWithdrawVerifier {
  function verifyProof(bytes memory _proof, uint256[6] memory _input) external returns (bool);
}

interface ICollectVerifier {
  function verifyProof(bytes memory _proof, uint256[4] memory _input) external returns (bool);
}

interface IEnoughVerifier {
  function verifyProof(bytes memory _proof, uint256[3] memory _input) external returns (bool);
}

contract HungTie is MerkleTreeWithHistory, ReentrancyGuard {

  ICollectVerifier public immutable collectVerifier;
  IEnoughVerifier public immutable enoughVerifier;
  IWithdrawVerifier public immutable withdrawVerifier;

  mapping(bytes32 => bool) public nullifierHashes;
  // we store all commitments just to prevent accidental deposits with the same commitment
  mapping(bytes32 => bool) public commitments;

  event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
  event Collect(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
  event Withdraw(address to, bytes32 nullifierHash, address indexed relayer, uint256 fee);

  constructor(
    ICollectVerifier _collectVerifier,
    IEnoughVerifier _enoughVerifier,
    IWithdrawVerifier _withdrawVerifier,
    IHasher _hasher,
    uint32 _merkleTreeHeight
  ) MerkleTreeWithHistory(_merkleTreeHeight, _hasher) {
    collectVerifier = _collectVerifier;
    enoughVerifier = _enoughVerifier;
    withdrawVerifier = _withdrawVerifier;
  }

  function deposit(bytes32 _commitment) external payable nonReentrant {
    require(!commitments[_commitment], "The commitment has been submitted");
    require(msg.value == 0.1 ether || msg.value == 1 ether || msg.value == 10 ether, "invalid denomination");

    uint32 insertedIndex = _insert(_commitment);
    commitments[_commitment] = true;

    emit Deposit(_commitment, insertedIndex, block.timestamp);
  }

  function withdraw(
    bytes calldata _proof,
    bytes32 _root,
    bytes32 _nullifierHash,
    address _recipient,
    address _relayer,
    uint256 _fee,
    uint256 _refund
  ) external payable nonReentrant {
    //require(_fee <= denomination, "Fee exceeds transfer value");
    require(!nullifierHashes[_nullifierHash], "The note has been already spent");
    require(isKnownRoot(_root), "Cannot find your merkle root"); // Make sure to use a recent one
    require(
      withdrawVerifier.verifyProof(
        _proof,
        [uint256(_root), uint256(_nullifierHash), uint256(uint160(_recipient)), uint256(uint160(_relayer)), _fee, _refund]
      ),
      "Invalid withdraw proof"
    );

    nullifierHashes[_nullifierHash] = true;
    emit Withdraw(_recipient, _nullifierHash, _relayer, _fee);
  }

  function collect(
    bytes calldata _proof,
    bytes32 _root,
    bytes32[32] calldata _nullifierHash,
    bytes32 _secretCommitment
  ) external nonReentrant {
    //collectVerifier.verifyProof(_proof, [uint256(_root), uint256(_nullifierHash), uint256(_secretCommitment), uint256(uint160(msg.sender))]);
  }

  function enough(
    bytes calldata _proof,
    bytes32 _root,
    bytes32 _commitment,
    bytes32 _thresholdCommitment
  ) external nonReentrant returns(bool) {
    return enoughVerifier.verifyProof(_proof, [uint256(_root), uint256(_commitment), uint256(_thresholdCommitment)]);
  }
}