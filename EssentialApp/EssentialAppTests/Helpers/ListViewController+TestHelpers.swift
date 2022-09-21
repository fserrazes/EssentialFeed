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
    func simulateFeedImageBecomingVisibleAgain(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewNotVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, willDisplay: view!, forRowAt: index)
        
        return view
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateLoadMoreFeedAction() {
        guard let view = loadMoreFeedCell() else {
            return
        }
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }
    
    func simulateTapOnLoadFeedError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    var isShowingLoadMoreFeedIndicator: Bool {
        return loadMoreFeedCell()?.isLoading == true
    }
    
    var loadMoreFeedErrorMessage: String? {
        return loadMoreFeedCell()?.message
    }
    
    var canLoadMoreFeed: Bool {
        return loadMoreFeedCell() != nil
    }
    
    private func loadMoreFeedCell() -> LoadMoreCell? {
        return cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return numberOfRows(in: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        return cell(row: row, section: feedImagesSection)
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    private var feedImagesSection: Int { return 0 }
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
