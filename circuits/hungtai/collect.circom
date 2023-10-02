include "../lib/merkleTree.circom";

template collect(levels) {
    signal input root;
    signal input nullifierHash[9];
    signal input commitment;

    signal private input nullifier;
    signal private input secret;
    signal private input amount;
    signal private input pathElements[9][levels];
    signal private input pathIndices[9][levels];
}

