//
//  Created by Flavio Serrazes on 04.02.21.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(id):
                return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
