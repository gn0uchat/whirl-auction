include "../lib/merkleTree.circom";

// leaf = hash(secret | amount)
template enough(levels) {
    signal input root;
    signal input commitment; // leaf = hash(isCollected | amount | secretHash)
                             // nullifier(i) = hash(nullifier(i-1) | secret), nullifier(0) = hash(secretHash | secret)
    signal input thresholdCommitment;  // thresholdCommitment = hash(salt | threshold)
    signal input isEnough;

    signal private input secret;
    signal private input salt;
    signal private input threshold;
    signal private input pathElements[levels];
    signal private input pathIndices[levels];
}

component main = Withdraw(20);
