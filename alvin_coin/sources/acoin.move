module alvin_coin::acoin{
    use std::option;
    use sui::coin::{Self,Coin,TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    struct ACOIN has drop {}

    fun init(waitness: ACOIN, ctx: &mut sui::tx_context::TxContext) {
        let (treasury_cap, meta) = coin::create_currency(waitness,2,b"ACOIN", b"ACN", b"", option::none(), ctx);
        transfer::public_freeze_object(meta);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<ACOIN>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
    }

    public entry fun burn(
        treasury_cap: &mut TreasuryCap<ACOIN>, coin : Coin<ACOIN>, _ctx: &mut TxContext
    ) {
        coin::burn(treasury_cap, coin);
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(ACOIN{}, ctx)
    }
}