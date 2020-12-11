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
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
