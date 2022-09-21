//
//  Created by Flavio Serrazes on 02.02.21.
//

import UIKit

 extension UIView {

     public func makeContainer() -> UIView {
         let container = UIView()
         container.backgroundColor = .clear
         container.addSubview(self)

         translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             leadingAnchor.constraint(equalTo: container.leadingAnchor),
             container.trailingAnchor.constraint(equalTo: trailingAnchor),
             topAnchor.constraint(equalTo: container.topAnchor),
             container.bottomAnchor.constraint(equalTo: bottomAnchor),
         ])

         return container
     }
 }
