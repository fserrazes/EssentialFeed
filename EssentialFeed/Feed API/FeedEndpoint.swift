//
//  Created by Flavio Serrazes on 04.02.21.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case .get:
                return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
