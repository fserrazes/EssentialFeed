//
//  Created by Flavio Serrazes on 22.10.20.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestURL = URL(string: "http://url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()

    private init() {}
    
    var requestURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_does_not_request_data_from_url() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_request_data_from_url() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestURL)
    }
}
