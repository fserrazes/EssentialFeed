//
//  Created by Flavio Serrazes on 01.12.20.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
