//
//  Created by Flavio Serrazes on 22.10.20.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_does_not_request_data_from_url() {
        let (_ , client) = makeSUT()
        XCTAssertTrue(client.requestURL.isEmpty)
    }
    
    func test_load_requests_data_from_url() {
        let url = URL(string: "http://given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURL, [url])
    }
    
    func test_load_twice_requests_data_from_url_twice() {
        let url = URL(string: "http://given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestURL, [url, url])
    }
    
    func test_load_delivers_error_on_client_error() {
        let (sut, client) = makeSUT()
        var remoteFeedLoaderErrors = [RemoteFeedLoader.Error]()
        let clientError = NSError(domain: #file, code: 0)
        
        sut.load { remoteFeedLoaderErrors.append($0) }
        client.complete(with: clientError)
        
        XCTAssertEqual(remoteFeedLoaderErrors, [.connectivity])
        
    }
    
    func test_load_delivers_error_on_non_200_http_response() {
        let (sut, client) = makeSUT()
        let sample = [199, 200, 300, 400, 500]
        
        sample.enumerated().forEach { (index, code) in
            var remoteFeedLoaderErrors = [RemoteFeedLoader.Error]()
            sut.load { remoteFeedLoaderErrors.append($0) }
            client.complete(with: code, at: index)
            
            XCTAssertEqual(remoteFeedLoaderErrors, [.invalidData])
        }
    }
    
    func test_load_delivers_error_on_200_http_response_with_invalid_json() {
        let (sut, client) = makeSUT()
        var remoteFeedLoaderErrors = [RemoteFeedLoader.Error]()
        
        sut.load { remoteFeedLoaderErrors.append($0) }
        
        let invalidJSON = Data("invalid json".utf8)
        client.complete(with: 200, data: invalidJSON)
        
        XCTAssertEqual(remoteFeedLoaderErrors, [.invalidData])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestURL: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with statusCode: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestURL[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
