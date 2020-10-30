//
//  Created by Flavio Serrazes on 30.10.20.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items)
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?)-> Void
    
    private (set) var deleteCachedFeedCallCount = 0
    private (set) var insertCachedFeedCallCount = 0
    
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deleteCachedFeedCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeSuccefully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem]) {
        insertCachedFeedCallCount += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_does_not_delete_cache_upon_creation() {
        let (_ , store) = makeSUT()
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requests_cache_deletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_does_not_request_insertion_on_deletion_error() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCachedFeedCallCount, 0)
    }
    
    func test_save_request_new_cache_insertion_on_deletion_successful() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        
        sut.save(items)
        store.completeSuccefully()
        
        XCTAssertEqual(store.insertCachedFeedCallCount, 1)
    }
    
    //MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueItem()-> FeedItem {
        return FeedItem(id: UUID(), description: "any description", location: "any location", imageUrl: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://given-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
