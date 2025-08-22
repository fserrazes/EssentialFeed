//
//  Created by Flavio Serrazes on 09.11.20.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_delivers_empty_on_empty_cache() throws
    func test_retrieve_has_no_side_effects_on_empty_cache() throws
    func test_retrieve_delivers_found_values_on_non_empty_cache() throws
    func test_retrieve_has_no_side_effects_on_non_empty_cache() throws

    func test_insert_delivers_no_error_on_empty_cache() throws
    func test_insert_delivers_no_error_on_non_empty_cache() throws
    func test_insert_overrides_previously_inserted_cache_values() throws

    func test_delete_delivers_no_error_on_empty_cache() throws
    func test_delete_has_no_side_effects_on_empty_cache() throws
    func test_delete_delivers_no_error_on_non_empty_cache() throws
    func test_delete_empties_previously_inserted_cache() throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_delivers_failure_on_retrieval_error() throws
    func test_retrieve_has_no_side_effects_on_failure() throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_delivers_error_on_insertion_error() throws
    func test_insert_has_no_side_effects_on_insertion_error() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_delivers_error_on_deletion_error() throws
    func test_delete_has_no_side_effects_on_deletion_error() throws
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs

