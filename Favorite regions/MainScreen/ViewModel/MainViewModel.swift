import Foundation

final class MainViewModel {
    // MARK: - Properties

    weak var delegate: MainViewModelDelegate? {
        didSet {
            getData()
        }
    }

    private let service: APIService

    private var regionsInfo = [RegionInfo]()

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

    // MARK: - Init

    required init(service: APIService) {
        self.service = service
        state = .none
    }

    // MARK: - Fetch data

    func getData() {
        state = .loading
        updateData()
    }

    func updateData() {
        service.loadMovies { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let info):
                self.regionsInfo = info
                self.state = .success
            case .failure:
                self.state = .error
            }
        }
    }

    func updateLikes(index: Int) {
        regionsInfo[index].overview.isLike = !regionsInfo[index].overview.isLike
    }

    // MARK: - Get data

    func getCount() -> Int {
        return regionsInfo.count
    }

    func getRegionOverview(index: Int) -> RegionOverview {
        return regionsInfo[index].overview
    }

    // MARK: - Open new screen

    func configDetailView(index: Int) {
        delegate?.openDetailView(
            next: DetailScreenBuilder(
                service: service,
                region: regionsInfo[index],
                delegate: self,
                index: index
            ).viewController
        )
    }
}

extension MainViewModel: ViewModelComunication {
    func reloadRow(index: Int) {
        delegate?.reloadRow(index: IndexPath(row: index, section: 0))
    }
}
