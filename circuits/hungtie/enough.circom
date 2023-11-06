pragma circom 2.1.4;

include "../lib/merkleTree.circom";

template enough(entries, levels) {
    signal input root;
    signal input commitment[entries]; // leaf = hash(secretHash + amount)
                             // nullifier(unit, i) = hash(nullifier(unit, i-1) | secret),
                             // nullifier(unit, 0) = hash(unit | secretHash | secret)
    signal input thresholdCommitment;  // thresholdCommitment = hash(thresholdSalt | threshold)

    signal input secret; // private
    signal input thresholdSalt; // private
    signal input threshold; // private
    signal input pathElements[entries][levels]; // private
    signal input pathIndices[entries][levels]; // private
}

component main { public [ root, commitment, thresholdCommitment ] } = enough(4, 20);
