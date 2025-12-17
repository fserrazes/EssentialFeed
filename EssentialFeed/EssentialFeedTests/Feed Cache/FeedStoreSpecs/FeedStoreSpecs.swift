//
//  Created by Flavio Serrazes on 09.11.20.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() async throws
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() async throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws

    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_overridesPreviouslyInsertedCacheValues() async throws

    func test_delete_deliversNoErrorOnEmptyCache() async throws
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws
    func test_delete_emptiesPreviouslyInsertedCache() async throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_delivers_failure_on_retrieval_error() async throws
    func test_retrieve_has_no_side_effects_on_failure() async throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_delivers_error_on_insertion_error() async throws
    func test_insert_has_no_side_effects_on_insertion_error() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_delivers_error_on_deletion_error() async throws
    func test_delete_has_no_side_effects_on_deletion_error() async throws
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs

