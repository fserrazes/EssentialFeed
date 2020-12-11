//
//  Created by Flavio Serrazes on 11.12.20.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}
class FeedPresentationTests: XCTestCase {
    
    func test_init_does_not_send_messages_to_view() {
        let (_, view) = makeSUT()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
