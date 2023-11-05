pragma circom 2.1.4;

include "../lib/merkleTree.circom";

template collect(levels) {
    signal input root;
    signal input secretCommitment[27];
    signal input newCommitment;

    // signal private input nullifier;
    signal input secret[27]; // private
    signal input amount[27]; // private
    signal input pathElements[9][levels]; // private
    signal input pathIndices[9][levels]; // private
}

component main { public [ root, secretCommitment[27], newCommitment ] } = collect();

