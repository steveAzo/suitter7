#[test_only]
module suitter::suitter_tests;

use suitter::suitter::{
    GlobalRegistry,
    register_suit,
    suit_exists,
    get_suit_author,
    create_test_registry,
    share_test_registry,
};
use sui::test_scenario;

const USER1: address = @0x1;
const USER2: address = @0x2;

#[test]
fun test_register_suit() {
    let mut scenario = test_scenario::begin(USER1);
    test_scenario::next_tx(&mut scenario, USER1);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        let mut registry = create_test_registry(ctx);
        
        let suit_id = sui::object::id_from_address(@0x123);
        let timestamp = 1000;
        
        // Register a suit
        register_suit(&mut registry, suit_id, USER1, timestamp, false, ctx);
        
        // Verify it was registered by checking if it exists
        assert!(suit_exists(&registry, suit_id), 0);
        
        // Share registry to avoid drop error
        share_test_registry(registry);
    };
    test_scenario::end(scenario);
}

#[test]
fun test_suit_exists() {
    let mut scenario = test_scenario::begin(USER1);
    test_scenario::next_tx(&mut scenario, USER1);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        let mut registry = create_test_registry(ctx);
        
        let suit_id = sui::object::id_from_address(@0x456);
        let fake_suit_id = sui::object::id_from_address(@0x999);
        
        // Register a suit
        register_suit(&mut registry, suit_id, USER1, 2000, false, ctx);
        
        // Test that registered suit exists
        assert!(suit_exists(&registry, suit_id), 1);
        
        // Test that non-existent suit doesn't exist
        assert!(!suit_exists(&registry, fake_suit_id), 2);
        
        share_test_registry(registry);
    };
    test_scenario::end(scenario);
}

#[test]
fun test_get_suit_author() {
    let mut scenario = test_scenario::begin(USER1);
    test_scenario::next_tx(&mut scenario, USER1);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        let mut registry = create_test_registry(ctx);
        
        let suit_id = sui::object::id_from_address(@0x789);
        
        // Register a suit with USER2 as author
        register_suit(&mut registry, suit_id, USER2, 3000, false, ctx);
        
        // Get the author
        let author_opt = get_suit_author(&registry, suit_id);
        
        // Verify we got the author
        assert!(std::option::is_some(&author_opt), 3);
        
        // Verify it's the correct author
        assert!(*std::option::borrow(&author_opt) == USER2, 4);
        
        share_test_registry(registry);
    };
    test_scenario::end(scenario);
}
