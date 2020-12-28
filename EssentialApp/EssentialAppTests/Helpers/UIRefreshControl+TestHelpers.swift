//
//  Created by Flavio Serrazes on 01.12.20.
//

import UIKit

extension UIRefreshControl {
    func simulatePullRefresh() {
        simulate(event: .valueChanged)
    }
}
