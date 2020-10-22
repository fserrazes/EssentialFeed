//
//  Created by Flavio Serrazes on 22.10.20.
//

import XCTest

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestURL: URL?
    
    func get(from url: URL) {
        requestURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_does_not_request_data_from_url() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://given-url.com")!
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_request_data_from_url() {
        let url = URL(string: "http://given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestURL, url)
    }
}
