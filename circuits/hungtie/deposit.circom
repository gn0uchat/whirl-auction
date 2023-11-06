pragma circom 2.1.4;

include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/pedersen.circom";

template deposit() {
    signal input amount; // secret
    signal input commitment; // leaf = hash(amount | recipientSecretHash | 0)

    signal input secret; // private

    component commitmentHasher = Pedersen(496);
    component amountBits = Num2Bits(248);
    component secretBits = Num2Bits(248);
    amountBits.in <== amount;
    secretBits.in <== secret;
    for (var i = 0; i < 248; i++) {
        commitmentHasher.in[i] <== amountBits.out[i];
        commitmentHasher.in[i + 248] <== secretBits.out[i];
    }

    log("hash", commitmentHasher.out[0]);

    commitment === commitmentHasher.out[0];
}

component main { public [ amount, commitment ] } = deposit();

/* INPUT = {
    "amount": "1",
    "commitment": "14506999730689772389431838309158543199841574746220952535750907741379419652223",
    "secret": "123"
} */
