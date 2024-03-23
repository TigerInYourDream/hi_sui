#[test_only]
module alvin_coin::acion_test {
    use sui::test_scenario::{Self,ctx};
    use sui::tx_context::sender;
    use std::debug;

    #[test]
    fun min_burn() {
        let address1 = @0xA;
        let scenario = test_scenario::begin(address1);
        debug::print(&sender(ctx(&mut scenario)));
        test_scenario::end(scenario);

    }
}