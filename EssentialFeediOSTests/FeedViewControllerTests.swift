//
//  Created by Flavio Serrazes on 27.11.20.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UIViewController {
    private var loader : FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_does_not_load_feed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loads_feed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping(FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
