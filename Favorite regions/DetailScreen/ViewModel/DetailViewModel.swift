import UIKit

protocol ViewModelComunication: AnyObject {
    func reloadRow(index: Int)
}

final class DetailViewModel {
    // MARK: - Properties

    weak var delegate: DetailViewModelDelegate? {
        didSet {
            getData()
        }
    }
    
    private let service: APIService
    private var region: RegionInfo
    private var images = [UIImage]()
    private let index: Int
    weak var mainViewModel: ViewModelComunication?
    
    // MARK: - Init

    required init(service: APIService, region: RegionInfo, index: Int, delegate: ViewModelComunication? = nil) {
        self.service = service
        self.region = region
        self.index = index
        mainViewModel = delegate
        state = .none
    }
    
    private var state: ScreenState {
        didSet {
            switch state {
            case .success:
                delegate?.updateView(state: .success)
            case .error:
                delegate?.updateView(state: .error)
            case .loading:
                delegate?.updateView(state: .loading)
            case .none:
                break
            }
        }
    }
    
    // MARK: - Fetch data

    func getData() {
        state = .loading
        for id in 0 ..< region.details.views.count {
            service.loadPicture(url: region.details.views[id]) { [weak self] res in
                guard let self = self else {
                    return
                }
                switch res {
                case .none:
                    self.state = .error
                case .some(let wrapped):
                    self.images.append(wrapped)
                    if region.details.views.count == id + 1 {
                        self.state = .success
                    }
                }
            }
        }
    }
    
    // MARK: - Get data

    func getDetailInfo() -> DetailInfo {
        DetailInfo(title: region.overview.title, viewCounts: region.details.viewCounts, isLike: region.overview.isLike)
    }
    
    func updateLikes() {
        region.overview.isLike = !region.overview.isLike
        mainViewModel?.reloadRow(index: index)
    }
    
    func getDataCount() -> Int {
        region.details.views.count
    }
    
    func getView(index: Int) -> UIImage {
        if index < images.count {
            return images[index]
        }
        return UIImage(systemName: "heart")!
    }
}
