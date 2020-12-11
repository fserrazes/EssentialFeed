//
//  Created by Flavio Serrazes on 11.12.20.
//

import UIKit

extension UIRefreshControl {
     func update(isRefreshing: Bool) {
         isRefreshing ? beginRefreshing() : endRefreshing()
     }
 }
