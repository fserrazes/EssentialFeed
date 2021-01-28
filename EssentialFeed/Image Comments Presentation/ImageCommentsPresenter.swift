//
//  Created by Flavio Serrazes on 28.01.21.
//

import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComments", bundle: bundle, comment: "Title for the iamge comments view")
    }
}
