module suitter::profile {
    use std::string::{String};
    use sui::clock::{Clock};
    use sui::table::{Self, Table};
    use suitter::suitter::{GlobalRegistry, increment_profiles, emit_profile_created};

    const EUsernameExists: u64 = 1;
    const EUsernameTooShort: u64 = 2;
    const EUsernameTooLong: u64 = 3;
    const EProfileNotFound: u64 = 4;
    const ENotProfileOwner: u64 = 5;

    const MIN_USERNAME_LENGTH: u64 = 3;
    const MAX_USERNAME_LENGTH: u64 = 20;

    public struct Profile has key, store {
        id: UID,
        owner: address,
        username: String,
        bio: String,
        profile_image_blob_id: Option<String>,
        suits_count: u64,
        followers_count: u64,
        following_count: u64,
        created_at_ms: u64,
    }

    public struct ProfileRegistry has key {
        id: UID,
        username_to_profile: Table<String, address>,
        address_to_username: Table<address, String>,
    }

    fun init(ctx: &mut TxContext) {
        let registry = ProfileRegistry {
            id: object::new(ctx),
            username_to_profile: table::new(ctx),
            address_to_username: table::new(ctx),
        };
        transfer::share_object(registry);
    }

    entry fun create_profile(
        global_registry: &mut GlobalRegistry,
        profile_registry: &mut ProfileRegistry,
        username: String,
        bio: String,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let username_length = username.length();
        assert!(username_length >= MIN_USERNAME_LENGTH, EUsernameTooShort);
        assert!(username_length <= MAX_USERNAME_LENGTH, EUsernameTooLong);

        let sender = ctx.sender();
        assert!(!table::contains(&profile_registry.username_to_profile, username), EUsernameExists);
        assert!(!table::contains(&profile_registry.address_to_username, sender), EUsernameExists);

        let profile = Profile {
            id: object::new(ctx),
            owner: sender,
            username,
            bio,
            profile_image_blob_id: option::none(),
            suits_count: 0,
            followers_count: 0,
            following_count: 0,
            created_at_ms: clock.timestamp_ms(),
        };

        let profile_id = object::id(&profile);
        
        table::add(&mut profile_registry.username_to_profile, username, sender);
        table::add(&mut profile_registry.address_to_username, sender, username);

        increment_profiles(global_registry);
        emit_profile_created(profile_id, sender, username);

        transfer::transfer(profile, sender);
    }

    entry fun update_bio(
        profile: &mut Profile,
        new_bio: String,
        ctx: &TxContext
    ) {
        assert!(profile.owner == ctx.sender(), ENotProfileOwner);
        profile.bio = new_bio;
    }

    entry fun update_profile_image(
        profile: &mut Profile,
        walrus_blob_id: String,
        ctx: &TxContext
    ) {
        assert!(profile.owner == ctx.sender(), ENotProfileOwner);
        profile.profile_image_blob_id = option::some(walrus_blob_id);
    }

    public(package) fun increment_suits_count(profile: &mut Profile) {
        profile.suits_count = profile.suits_count + 1;
    }

    public fun get_profile_by_username(
        registry: &ProfileRegistry,
        username: String
    ): Option<address> {
        if (table::contains(&registry.username_to_profile, username)) {
            option::some(*table::borrow(&registry.username_to_profile, username))
        } else {
            option::none()
        }
    }

    public fun get_username_by_address(
        registry: &ProfileRegistry,
        addr: address
    ): Option<String> {
        if (table::contains(&registry.address_to_username, addr)) {
            option::some(*table::borrow(&registry.address_to_username, addr))
        } else {
            option::none()
        }
    }

    public fun owner(profile: &Profile): address {
        profile.owner
    }

    public fun username(profile: &Profile): String {
        profile.username
    }

    public fun bio(profile: &Profile): String {
        profile.bio
    }

    public fun profile_image_blob_id(profile: &Profile): &Option<String> {
        &profile.profile_image_blob_id
    }

    public fun suits_count(profile: &Profile): u64 {
        profile.suits_count
    }

    public fun created_at_ms(profile: &Profile): u64 {
        profile.created_at_ms
    }
}