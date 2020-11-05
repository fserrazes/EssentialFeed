//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Flavio Serrazes on 05.11.20.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://given-url.com")!
}
