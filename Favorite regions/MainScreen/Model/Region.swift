import UIKit

class RegionInfo {
    let id: String
    var overview: RegionOverview
    let details: RegionDetails

    init(id: String, overview: RegionOverview, details: RegionDetails) {
        self.id = id
        self.overview = overview
        self.details = details
    }
}

struct RegionOverview {
    let title: String
    var view: UIImage?
    var isLike: Bool
}

struct RegionDetails {
    let viewCounts: Int
    let views: [String]
}
