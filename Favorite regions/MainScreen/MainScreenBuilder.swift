import Foundation

struct MainScreenBuilder {
    let viewController: MainViewController
    private let viewModel: MainViewModel
    init(service: APIService) {
        viewModel = MainViewModel(service: service)
        viewController = MainViewController(viewModel: viewModel)
        viewModel.delegate = viewController
    }
}
