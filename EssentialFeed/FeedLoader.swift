//
//  Created by Flavio Serrazes on 22.10.20.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
    
}
protocol FeedLoader {
    func load(completion: @escaping(LoadFeedResult) -> Void)
}
