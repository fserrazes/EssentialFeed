//
//  Created by Flavio Serrazes on 05.02.21.
//

import UIKit
import EssentialFeed

public class LoadMoreCellController: NSObject, UITableViewDataSource {
    private let cell = LoadMoreCell()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
}

extension LoadMoreCellController: ResourceLoadingView {
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}
