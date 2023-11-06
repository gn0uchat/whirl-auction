pragma circom 2.1.4;

include "../lib/merkleTree.circom";

template collect(entries, levels) {
    signal input root;
    signal input fromEntryCommitment[entries];
    signal input toEntryCommitment; // leaf = hash(toEntryAmount | recipientSecretHash | semaphoreSecret)
    signal input nullifiers[entries]; // nullifier = hash()
    signal input relayer;
    signal input recipientSecretHash;

    // signal private input nullifier;
    signal input fromEntrySecret[entries]; // private
    signal input fromEntryAmount[entries]; // private
    signal input toEntryAmount; // private
    signal input pathElements[entries][levels]; // private
    signal input pathIndices[entries][levels]; // private
    signal input semaphoreSecret; // private
}

component main { public [root, fromEntryCommiment, toEntryCommitment, nullifiers, relayer, recipientSecretHash] } = collect(8, 20);

// exchangeSecret = hash()
