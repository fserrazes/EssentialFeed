//
//  Created by Flavio Serrazes on 26.10.20.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_get_from_url_performs_get_request_with_url() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.requestObserver { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_get_from_url_fails_on_requests_error() {
//        let requestError = anyNSError()
//        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
//
//        XCTAssertEqual(receivedError as NSError?, requestError)
    }
    
    func test_get_from_url_fails_on_all_invalid_representation_cases() {
        XCTAssertNotNil(resultErrorFor(data: nil      , response: nil                 , error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil      , response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil                 , error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil                 , error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil      , response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil      , response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_get_from_url_success_with_empty_data_on_http_url_response_with_nil_data() {
        let data = Data()
        let response = anyHTTPURLResponse()
        
        let resultValues = resultValuesFor(data: nil, response: response, error: nil)
        
        XCTAssertEqual(resultValues?.data, data) // if empty data
        XCTAssertEqual(resultValues?.response.url, response.url)
        XCTAssertEqual(resultValues?.response.statusCode, response.statusCode)
    }
    
    func test_get_from_url_success_on_http_url_response_with_data() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let resultValues = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(resultValues?.data, data)
        XCTAssertEqual(resultValues?.response.url, response.url)
        XCTAssertEqual(resultValues?.response.statusCode, response.statusCode)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?,
            file: StaticString = #filePath, line: UInt = #line) -> Error? {
        
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
            case let .failure(error):
                return error
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
                return nil
        }
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?,
            file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
            case let .success(data, response):
                return (data, response)
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
                return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?,
            file: StaticString = #filePath, line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static func requestObserver(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
