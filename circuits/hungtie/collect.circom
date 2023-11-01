pragma circom 2.1.4;

include "../lib/merkleTree.circom";

template collect(levels) {
    signal input root;
    signal input nullifierHash[27]; 
    signal input secretCommitment;
    signal input relayer;

    // signal private input nullifier;
    signal input secret[27]; // private
    signal input amount; // private
    signal input pathElements[9][levels]; // private
    signal input pathIndices[9][levels]; // private
}

component main { public [ root, nullifierHash[27], secretCommitment, relayer ] } = collect();

