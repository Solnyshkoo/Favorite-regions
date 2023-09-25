import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func updateView(state: ScreenState)
}

final class DetailViewController: UIViewController {
    // MARK: - Properties

    private let detailViewModel: DetailViewModel
    private let infoView = DetailInfoView()
    private let tableView = UITableView()
    private let loadingView = UIActivityIndicatorView()
    private let errorView: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то не так, попробуйте позже", preferredStyle: .alert)
        return alert
    }()
    
    // MARK: - Init

    init(viewModel: DetailViewModel) {
        detailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Set up view

    func setUpView() {
        view.addSubview(infoView)
        infoView.config(info: detailViewModel.getDetailInfo(), delegate: self)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        let updateAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.detailViewModel.getData()
        }
        errorView.addAction(updateAction)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 110)
            
        ])
    }
    
    // MARK: - Set up TableView

    func setUpTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.dataSource = self
        tableView.rowHeight = 160
        tableView.separatorColor = .clear
        tableView.register(RegionPhotoCell.self, forCellReuseIdentifier: RegionPhotoCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    // MARK: - Loading view and error view

    func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .systemBlue
        loadingView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: infoView.bounds.height + 10)
        ])
    }
    
    func showErrorView() {
        tableView.isHidden = true
        present(errorView, animated: true)
    }
}

// MARK: - DetailViewModelDelegate

extension DetailViewController: DetailViewModelDelegate {
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
            }
        case .success:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.loadingView.stopAnimating()
                self.setUpTableView()
            }
        case .none:
            break
        }
    }
}

// MARK: - DetailInfoViewDelegate

extension DetailViewController: DetailInfoViewDelegate {
    func likeActoin() {
        detailViewModel.updateLikes()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailViewModel.getDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = detailViewModel.getView(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RegionPhotoCell.reuseIdentifier, for: indexPath
        ) as? RegionPhotoCell else {
            return UITableViewCell()
        }
        cell.config(view: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}
