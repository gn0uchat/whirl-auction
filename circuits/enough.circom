include "merkleTree.circom";

// leaf = hash(secret | amount)
template enough(levels) {
    signal input root;
    signal input secretHash; // secretHash = hash(secret)
    signal input leaf; // leaf = hash(secret | secretHash | amount)
    signal input thresholdHash;  // priceHash = hash(secret | threshold)

    signal private input secret;
    signal private input threshold;
    signal private input pathElements[levels];
    signal private input pathIndices[levels];
}

component main = Withdraw(20);
