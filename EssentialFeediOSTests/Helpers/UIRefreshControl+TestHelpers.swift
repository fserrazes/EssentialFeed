//
//  Created by Flavio Serrazes on 01.12.20.
//

import UIKit

extension UIRefreshControl {
    func simulatePullRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
