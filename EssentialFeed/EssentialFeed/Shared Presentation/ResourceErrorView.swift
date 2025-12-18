//
//  Created by Flavio Serrazes on 28.01.21.
//

import Foundation

@MainActor
public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}
