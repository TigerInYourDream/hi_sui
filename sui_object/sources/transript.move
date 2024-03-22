module sui_object::transript{
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;
    use sui::event;

    struct TranscriptObject has key {
        id: UID,
        history: u8,
        math: u8,
        literature: u8
    }

    public entry fun create_transcript_object(_ : &TeacherCapbility ,history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
        let transcript_object= TranscriptObject { 
            id: object::new(ctx),
            history,
            math,
            literature, 
        };

        transfer::transfer(transcript_object, tx_context::sender(ctx))
        // transfer::freeze_object(transcript_object)
        // transfer::share_object(transcript_object)
    }

    public fun view_literature_score(transcriptobject: &TranscriptObject) : u8{
        transcriptobject.literature
    }

    public fun view_math_sore(transcriptobject: &TranscriptObject) : u8{
        transcriptobject.math
    }
    
    public fun view_histort_score(transcriptobject: &TranscriptObject) : u8{
        transcriptobject.history
    }
    
    public fun update_literature_score(transcriptobject: &mut TranscriptObject, score: u8) {
        transcriptobject.literature = score;
    }

    public entry fun delete_transcript_object(transcript_object: TranscriptObject) {
        let TranscriptObject {id, history: _, math: _, literature: _, } = transcript_object;
        object::delete(id)
    }

    struct WarpTransciptObject has key, store {
        id: UID,
        history: u8,
        math: u8,
        literature: u8
    } 

    struct Foler has key {
        id: UID,
        transcipt: WarpTransciptObject,
        intended_address: address,
    }

    const ENotIntendedAddress: u64 = 1;

    fun init(ctx: &mut sui::tx_context::TxContext) {
        transfer::transfer(TeacherCapbility {
            id: object::new(ctx),
        }, tx_context::sender(ctx));
    }

    public entry fun request_transcript(transcipt: WarpTransciptObject, intended_address:address, ctx: &mut TxContext) {
        let foler_object = Foler {
            id: object::new(ctx),
            transcipt,
            intended_address,
        };

        event::emit(TransciptRequestEvent {
            wrap_id: object::uid_to_inner(&foler_object.id),
            requester: tx_context::sender(ctx),
            intended_address
        });

        transfer::transfer(foler_object, intended_address);
    } 

    public entry fun unpack_foler_object(folder: Foler, ctx: &mut TxContext) {
        assert!(folder.intended_address==tx_context::sender(ctx), ENotIntendedAddress);
        let Foler {id, transcipt, intended_address: _} = folder;
        transfer::transfer(transcipt, tx_context::sender(ctx));
        // because Foler dont have ability to drop 
        object::delete(id);
    }

    struct TeacherCapbility has key {
        id: UID
    }

    struct TransciptRequestEvent has drop, copy {
        wrap_id: ID,
        requester: address,
        intended_address: address,
    }
}