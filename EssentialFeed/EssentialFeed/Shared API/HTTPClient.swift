//
//  Created by Flavio Serrazes on 26.10.20.
//

import Foundation

public protocol HTTPClientTask {
     func cancel()
}

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
