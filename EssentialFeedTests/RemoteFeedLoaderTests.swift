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
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let data = serialize([])
                client.complete(with: code, data: data, at: index)
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
            let data = serialize([])
            client.complete(with: 200, data: data)
        })
    }
    
    func test_load_delivers_items_on_200_http_response_with_json_items() {
        let (sut, client) = makeSUT()
        
        let item1 = makeJsonItem(id: UUID(), imageUrl: URL(string: "http://given-image-url.com")!)

        let item2 = makeJsonItem(id: UUID(), description: "a description", location: "a location",
                             imageUrl: URL(string: "http://given-another-image-url.com")!)
        
        let items = [item1.model, item2.model]

        expect(sut, toCompleteWith: .success(items), when: {
            let data = serialize([item1.json, item2.json])
            client.complete(with: 200, data: data)
        })
    }
    
    func test_load_does_not_delivers_result_after_sut_instance_has_been_deallocated() {
        let url = URL(string: "http://given-any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var results = [RemoteFeedLoader.Result]()
        sut?.load { results.append($0) }
        
        sut = nil
        client.complete(with: 200, data: serialize([]))
        
        XCTAssertTrue(results.isEmpty)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        
        return (sut, client)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potencial memory leak.",
                file: file, line: line)
        }
    }
    
    private func makeJsonItem(id: UUID, description: String? = nil, location: String? = nil , imageUrl: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(id: id, description: description, location: location, imageUrl: imageUrl)
        
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageUrl.absoluteString
        ].reduce(into: [String: Any]()) { (acc, element) in
            if let value = element.value { acc[element.key] = value }
        }
        
        return (item, json)
    }
    
    private func serialize(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": items])
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
        
        func complete(with statusCode: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestURL[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
