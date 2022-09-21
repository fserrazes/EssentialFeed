//
//  Created by Flavio Serrazes on 19.12.20.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
