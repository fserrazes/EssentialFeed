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
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: #file, code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_delivers_error_on_non_200_http_response() {
        let (sut, client) = makeSUT()
        let sample = [199, 200, 300, 400, 500]
        
        sample.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(with: code, at: index)
            })
        }
    }
    
    func test_load_delivers_error_on_200_http_response_with_invalid_json() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(with: 200, data: invalidJSON)
        })
    }
    
    func test_load_delivers_no_items_on_200_http_response_with_empty_list() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyJSON = Data("{\"items\": []}".utf8)
            client.complete(with: 200, data: emptyJSON)
        })
    }
    
    func test_load_delivers_items_on_200_http_response_with_json_items() {
        let (sut, client) = makeSUT()
        
        let item1 = FeedItem(id: UUID(), description: nil, location: nil,
                             imageUrl: URL(string: "http://given-image-url.com")!)
        
        let item1JSON = [
            "id": item1.id.uuidString,
            "image": item1.imageUrl.absoluteString
        ]
    
        let item2 = FeedItem(id: UUID(), description: "a description", location: "a location",
                             imageUrl: URL(string: "http://given-another-image-url.com")!)
        
        let item2JSON = [
            "id": item2.id.uuidString,
            "description": item2.description,
            "location": item2.location,
            "image": item2.imageUrl.absoluteString
        ]
        
        let itemsJSON = ["items": [item1JSON, item2JSON]]
        
        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            let data = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(with: 200, data: data)
        })

        
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result,
        when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        var results = [RemoteFeedLoader.Result]()
        sut.load { results.append($0) }
        
        action()
        
        XCTAssertEqual(results, [result], file: file, line: line)
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
