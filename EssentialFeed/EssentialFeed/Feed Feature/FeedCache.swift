//
//  Created by Flavio Serrazes on 19.12.20.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
