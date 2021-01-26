//
//  Created by Flavio Serrazes on 23.10.20.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
