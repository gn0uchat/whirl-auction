#Whirl Auction

Parties:
-------
- Seller
- Bidders

Contracts:
----------
- Auction Contract (WhirlAuction) functions:
    - auction(leaf(auction_info))
    - bid(proof(secret(bidder), siblings[9]), nullifier_hash[9], leaf(hash(secret(seller), collect_sum)))
        * set pause_info
            + set is_paused
            + set latest_bid_block_i
            + set latest_bid_leaf_i
        * for each denomination d:
            + call--> collect
    - slash(proof(secret(seller), pause_time, current_price, leaf_with_siblings(auction_info)), current_block_i)
        * for each denomination d:
            + require(is_paused && latest_bid_block_i < current_block_i <= latest_bid_block_i + pause_time)
            + require(check(proof(secret(seller), current_price, leaf_with_siblings(hash(secret(seller), current_price), false))))
        * unset pause_info
            +unset is_paused
- Cash Contract (HongtaiCash) functions (with denomination d(e.g 100, 10, 1, 0.1)):
    * deposit(leaf(hash(secret(user)), 1))
    * withdraw(proof(secret(user), siblings), nullifier_hash, recipient)
    * collect(proof(secret(user), siblings[9]), nullifier_hash[9], leaf(hash(secret(user)), collect_sum))
        + Emit--> Collect(commitment, leafIndex, timestamp)
        + return leafIndex
    * check(proof(secret(owner), sum, leaf(hash(secret(seller), sum), siblings, is_correct))
        +returns bool

Workflow:
--------
1) Seller creates an auction with auction_info:
    - Hash(secret(seller))
    - init price
    - pause time
    - price delta
    - time delta
2) seller --call--> auction(leaf(auction_info))
3) Bidder --call--> bid before price goes to zero
4) Seller:
    1) slash within pausiing period, auction restart
    2) auction end after pausing period
5) auction ended, bidder is authorised to receive token
