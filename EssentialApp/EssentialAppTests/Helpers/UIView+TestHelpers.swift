//
//  Created by Flavio Serrazes on 30.12.20.
//

import UIKit

extension UIView {
     func enforceLayoutCycle() {
         layoutIfNeeded()
         RunLoop.current.run(until: Date())
     }
}
