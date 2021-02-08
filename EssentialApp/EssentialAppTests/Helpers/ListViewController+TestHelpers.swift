//
//  Created by Flavio Serrazes on 01.12.20.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        tableView.frame = .zero
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    var errorMessage: String? {
        return errorView.message
    }
}

extension ListViewController {
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateLoadMoreFeedAction() {
        guard let view = cell(row: 0, section: feedLoadMoreSection) else {
            return
        }
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return numberOfRows(in: feedImageSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        return cell(row: row, section: feedImageSection)
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    private var feedImageSection: Int { return 0 }
    private var feedLoadMoreSection: Int { return 1 }
}

extension ListViewController {
    func numberOfRenderedCommmentsViews() -> Int {
        return numberOfRows(in: commentsSection)
    }
    
    private var commentsSection: Int {
        return 0
    }
    
    private func commentView(at row: Int) -> ImageCommentCell? {
        return cell(row: row, section: commentsSection) as? ImageCommentCell
    }
    
    func commentMessage(at row: Int) -> String? {
        return commentView(at: row)?.messageLabel.text
    }
    
    func commentDate(at row: Int) -> String? {
        return commentView(at: row)?.dateLabel.text
    }
    
    func commentUsername(at row: Int) -> String? {
        return commentView(at: row)?.usernameLabel.text
    }
}
