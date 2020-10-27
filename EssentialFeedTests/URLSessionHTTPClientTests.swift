//
//  Created by Flavio Serrazes on 26.10.20.
//

import XCTest
import EssentialFeed


class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) {_, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_get_from_url_performs_get_request_with_url() {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://given-url.com")!
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.requestObserver { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        sut.get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_get_from_url_fails_on_requests_error() {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://given-url.com")!
        let error = NSError(domain: "fails", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for load completion")
        sut.get(from: url) { result in
            switch result {
                case let .failure(receivedError as NSError):
                    XCTAssertEqual(receivedError, error)
                default:
                    XCTFail("Expected failure with \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    
    
    //MARK: - Helpers
    
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
            requestObserver?(request)
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
