include "../lib/merkleTree.circom";

template owner(levels) {
    signal input root;
    signal input commitment; // leaf commitment = hash(secret + secretCommitment + amount)
                             // nullifier(i) = hash(nullifier(i-1) | secret), nullifier(0) = hash(secretHash | secret)
    signal input secretCommitment;

    signal private input secret;
    signal private input amount;
    signal private input pathElements[levels];
    signal private input pathIndices[levels];
}
