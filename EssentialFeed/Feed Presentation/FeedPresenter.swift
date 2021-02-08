//
//  Created by Flavio Serrazes on 12.12.20.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        let bundle = Bundle(for: FeedPresenter.self)
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: bundle, comment: "Title for the feed view")
    }
}

