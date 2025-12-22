//  Created on 22/08/2025
//  Copyright © 2025 Flavio Serrazes. All rights reserved.

import Foundation

protocol FeedImageDataStoreSpecs {
	func test_retrieveImageData_deliversNotFoundWhenEmpty() async throws
	func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws
	func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws
	func test_retrieveImageData_deliversLastInsertedValue() async throws
}
