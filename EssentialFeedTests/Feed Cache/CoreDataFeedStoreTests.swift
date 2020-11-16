//
//  Created by Flavio Serrazes on 16.11.20.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_delivers_empty_on_empty_cache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_has_no_side_effects_on_empty_cache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_delivers_found_values_on_non_empty_cache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_has_no_side_effects_on_non_empty_cache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_insert_delivers_no_error_on_empty_cache() {
        
    }
    
    func test_insert_delivers_no_error_on_non_empty_cache() {
        
    }
    
    func test_insert_overrides_previously_inserted_cache_values() {
        
    }
    
    func test_delete_delivers_no_error_on_empty_cache() {
        
    }
    
    func test_delete_has_no_side_effects_on_empty_cache() {
        
    }
    
    func test_delete_delivers_no_error_on_non_empty_cache() {
        
    }
    
    func test_delete_empties_previously_inserted_cache() {
        
    }
    
    func test_store_side_effects_run_serially() {
        
    }
    
    // - MARK: Helpers
         
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
