//
//  Created by Flavio Serrazes on 19.11.20.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {

    func test_load_delivers_no_items_on_empty_cache() {
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for load completion")
        sut.load { result in
            switch result {
                case let .success(imageFeed):
                    XCTAssertEqual(imageFeed, [], "Expected empty feed")
                case let .failure(error):
                    XCTFail("Expected successful feed result, got \(error) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_delivers_items_saved_on_separate_instance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        let saveExpectation = expectation(description: "Wait for save completion")
        sutToPerformSave.save(feed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed suceessfuly")
            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 1.0)
        
        let loadExpectation = expectation(description: "Wait for load completion")
        sutToPerformLoad.load { loadResult in
            switch loadResult {
                case let .success(imageFeed):
                    XCTAssertEqual(imageFeed, feed)
                
                case let .failure(error):
                    XCTFail("Expected successful feed result, got \(error) instead")
            }
            
            loadExpectation.fulfill()
        }
        wait(for: [loadExpectation], timeout: 1.0)
    }
    
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
