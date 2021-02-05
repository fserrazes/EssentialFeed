//
//  Created by Flavio Serrazes on 05.02.21.
//

import UIKit

public class LoadMoreCell: UITableViewCell {
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: 40)
        ])
        return spinner
    }()
    
    public var isLoading: Bool {
        get { spinner.isAnimating }
        set { newValue ? spinner.startAnimating() : spinner.stopAnimating() }
    }
}
