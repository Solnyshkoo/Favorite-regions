import UIKit

protocol MainViewModelDelegate: AnyObject {
    func updateView(state: ScreenState)
    func reloadRow(index: IndexPath)
    func openDetailView(next: UIViewController)
}

final class MainViewController: UIViewController {
    // MARK: - Properties

    private let mainViewModel: MainViewModel
    
    private let tableLoadingView = UIRefreshControl()
    private let loadingView = UIActivityIndicatorView()
    private let tableView = UITableView()
    private let errorView: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то не так, попробуйте позже", preferredStyle: .alert)
        return alert
    }()
    
    // MARK: - Init

    init(viewModel: MainViewModel) {
        mainViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
        let updateAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.mainViewModel.getData()
        }
        errorView.addAction(updateAction)
    }
    
    // MARK: - Loading view and error view

    func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .systemBlue
        loadingView.transform = CGAffineTransform(scaleX: 2, y: 2)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showErrorView() {
        tableView.isHidden = true
        present(errorView, animated: true)
    }

    // MARK: - TableView

    func setUpTableView() {
        view.addSubview(tableView)
        tableView.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RegionCell.self, forCellReuseIdentifier: RegionCell.reuseIdentifier)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func handleRefreshControl() {
        mainViewModel.updateData()
    }
}

// MARK: - MainViewModelDelegate

extension MainViewController: MainViewModelDelegate {
    func updateView(state: ScreenState) {
        switch state {
        case .loading:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.showLoadingView()
                self.loadingView.startAnimating()
            }
            
        case .error:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.loadingView.stopAnimating()
                self.showErrorView()
                if self.tableView.refreshControl?.isRefreshing ?? false {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
           
        case .success:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.loadingView.stopAnimating()
                if self.tableView.refreshControl?.isRefreshing ?? false {
                    self.tableView.refreshControl?.endRefreshing()
                }
                self.setUpTableView()
                self.tableView.reloadData()
            }
            
        case .none:
            break
        }
    }
    
    func reloadRow(index: IndexPath) {
        tableView.reloadRows(at: [index], with: .none)
    }
    
    func openDetailView(next: UIViewController) {
        present(next, animated: true, completion: nil)
    }
}

// MARK: - RegionCellDelegate

extension MainViewController: RegionCellDelegate {
    func likeActoin(row: Int) {
        mainViewModel.updateLikes(index: row)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = mainViewModel.getRegionOverview(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RegionCell.reuseIdentifier, for: indexPath
        ) as? RegionCell else {
            return UITableViewCell()
        }
        
        cell.config(index: indexPath.row, info: data, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainViewModel.configDetailView(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}
