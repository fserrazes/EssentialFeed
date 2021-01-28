//
//  Created by Flavio Serrazes on 12.12.20.
//

import Foundation

public final class FeedImagePresenter {
    public static func map (_ image: FeedImage) -> FeedImageViewModel {
        return FeedImageViewModel(description: image.description, location: image.location)
        
    }
}
