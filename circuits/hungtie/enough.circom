pragma circom 2.1.4;

include "../lib/merkleTree.circom";

template enough(levels) {
    signal input root;
    signal input commitment; // leaf = hash(secretHash + amount)
                             // nullifier(i) = hash(nullifier(i-1) | secret), nullifier(0) = hash(secretHash | secret)
    signal input thresholdCommitment;  // thresholdCommitment = hash(salt | threshold)

    signal input secret; // private
    signal input salt; // private
    signal input threshold; // private
    signal input pathElements[levels]; // private
    signal input pathIndices[levels]; // private
}

component main { public [ root, commitment, thresholdCommitment ] } = Withdraw(20);
