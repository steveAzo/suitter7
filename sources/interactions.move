module suitter::interactions {
    use std::string::{String};
    use sui::clock::{Clock};
    use sui::table::{Self, Table};
    use suitter::suit::{Self, Suit};
    use suitter::suitter::{GlobalRegistry, increment_likes, increment_comments, emit_like_added, emit_comment_added};

    const EAlreadyLiked: u64 = 1;
    const ECommentTooLong: u64 = 2;
    const ECommentEmpty: u64 = 3;

    const MAX_COMMENT_LENGTH: u64 = 280;

    public struct Like has key, store {
        id: UID,
        suit_id: ID,
        liker: address,
        timestamp_ms: u64,
    }

    public struct Comment has key, store {
        id: UID,
        suit_id: ID,
        author: address,
        content: String,
        timestamp_ms: u64,
    }

    public struct LikeRegistry has key {
        id: UID,
        suit_likes: Table<ID, Table<address, bool>>,
    }

    fun init(ctx: &mut TxContext) {
        let registry = LikeRegistry {
            id: object::new(ctx),
            suit_likes: table::new(ctx),
        };
        transfer::share_object(registry);
    }

    public fun like_suit(
        global_registry: &mut GlobalRegistry,
        like_registry: &mut LikeRegistry,
        suit: &mut Suit,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let suit_id = object::id(suit);
        let liker = ctx.sender();

        if (!table::contains(&like_registry.suit_likes, suit_id)) {
            table::add(&mut like_registry.suit_likes, suit_id, table::new(ctx));
        };

        let likes_table = table::borrow_mut(&mut like_registry.suit_likes, suit_id);
        assert!(!table::contains(likes_table, liker), EAlreadyLiked);

        let like = Like {
            id: object::new(ctx),
            suit_id,
            liker,
            timestamp_ms: clock.timestamp_ms(),
        };

        table::add(likes_table, liker, true);
        suit::increment_likes(suit);
        increment_likes(global_registry);
        emit_like_added(suit_id, liker);

        transfer::share_object(like);
    }

    public fun comment_on_suit(
        global_registry: &mut GlobalRegistry,
        suit: &mut Suit,
        content: String,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let content_length = content.length();
        assert!(content_length > 0, ECommentEmpty);
        assert!(content_length <= MAX_COMMENT_LENGTH, ECommentTooLong);

        let suit_id = object::id(suit);
        let comment = Comment {
            id: object::new(ctx),
            suit_id,
            author: ctx.sender(),
            content,
            timestamp_ms: clock.timestamp_ms(),
        };

        let comment_id = object::id(&comment);
        
        suit::increment_comments(suit);
        increment_comments(global_registry);
        emit_comment_added(suit_id, comment_id, ctx.sender());

        transfer::share_object(comment);
    }

    public fun has_liked(
        like_registry: &LikeRegistry,
        suit_id: ID,
        user: address
    ): bool {
        if (!table::contains(&like_registry.suit_likes, suit_id)) {
            return false
        };

        let likes_table = table::borrow(&like_registry.suit_likes, suit_id);
        table::contains(likes_table, user)
    }

    public fun like_suit_id(like: &Like): ID {
        like.suit_id
    }

    public fun liker(like: &Like): address {
        like.liker
    }

    public fun like_timestamp_ms(like: &Like): u64 {
        like.timestamp_ms
    }

    public fun comment_suit_id(comment: &Comment): ID {
        comment.suit_id
    }

    public fun comment_author(comment: &Comment): address {
        comment.author
    }

    public fun comment_content(comment: &Comment): String {
        comment.content
    }

    public fun comment_timestamp_ms(comment: &Comment): u64 {
        comment.timestamp_ms
    }
}