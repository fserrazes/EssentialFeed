//
//  Created by Flavio Serrazes on 09.11.20.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_delivers_empty_on_empty_cache()
    func test_retrieve_has_no_side_effects_on_empty_cache()
    func test_retrieve_delivers_found_values_on_non_empty_cache()
    func test_retrieve_has_no_side_effects_on_non_empty_cache()

    func test_insert_delivers_no_error_on_empty_cache()
    func test_insert_delivers_no_error_on_non_empty_cache()
    func test_insert_overrides_previously_inserted_cache_values()

    func test_delete_delivers_no_error_on_empty_cache()
    func test_delete_has_no_side_effects_on_empty_cache()
    func test_delete_delivers_no_error_on_non_empty_cache()
    func test_delete_empties_previously_inserted_cache()

    func test_store_side_effects_run_serially()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_delivers_failure_on_retrieval_error()
    func test_retrieve_has_no_side_effects_on_failure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_delivers_error_on_insertion_error()
    func test_insert_has_no_side_effects_on_insertion_error()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_delivers_error_on_deletion_error()
    func test_delete_has_no_side_effects_on_deletion_error()
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs

