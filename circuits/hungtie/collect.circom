include "../lib/merkleTree.circom";

template collect(levels) {
    signal input root;
    signal input nullifierHash[32]; 
    signal input secretCommitment;
    signal input relayer;

    // signal private input nullifier;
    signal private input secret[32];
    signal private input amount;
    signal private input pathElements[9][levels];
    signal private input pathIndices[9][levels];
}

