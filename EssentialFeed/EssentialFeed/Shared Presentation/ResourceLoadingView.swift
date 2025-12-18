//
//  Created by Flavio Serrazes on 28.01.21.
//

import Foundation

@MainActor
public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}
