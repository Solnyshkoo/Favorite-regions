import Foundation

struct DetailScreenBuilder {
    let viewController: DetailViewController
    private let viewModel: DetailViewModel

    init(service: APIService, region: RegionInfo, delegate: ViewModelComunication, index: Int) {
        viewModel = DetailViewModel(service: service, region: region, index: index, delegate: delegate)
        viewController = DetailViewController(viewModel: viewModel)
        viewModel.delegate = viewController
    }
}
