//
//  Created by Flavio Serrazes on 22.10.20.
//

import Foundation

public struct ImageComment: Hashable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String
    
    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
