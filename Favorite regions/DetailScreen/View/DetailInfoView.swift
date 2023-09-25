import UIKit

protocol DetailInfoViewDelegate: AnyObject {
    func likeActoin()
}

final class DetailInfoView: UIView {
    weak var delegate: DetailInfoViewDelegate?
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let like: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "heart"))
        view.tintColor = .systemRed
        view.tag = 0
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewsCount: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        like.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLike)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(info: DetailInfo, delegate: DetailInfoViewDelegate) {
        title.text = info.title
        viewsCount.text = "Просмотры: " + info.viewCounts.description
        self.delegate = delegate
        
        if info.isLike {
            like.image = UIImage(systemName: "heart.fill")
            like.tag = 1
        } else {
            like.image = UIImage(systemName: "heart")
            like.tag = 0
        }
    }
    
    @objc func selectLike(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.likeActoin()
        if like.tag == 0 {
            like.image = UIImage(systemName: "heart.fill")
            like.tag = 1
        } else {
            like.image = UIImage(systemName: "heart")
            like.tag = 0
        }
    }
    
    private func setupCell() {
        addSubview(title)
        addSubview(like)
        addSubview(viewsCount)
        
        NSLayoutConstraint.activate([
            like.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            like.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            like.widthAnchor.constraint(equalToConstant: 30),
            like.heightAnchor.constraint(equalToConstant: 30),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: like.leadingAnchor, constant: -10),
            title.heightAnchor.constraint(equalToConstant: 50),
            
            viewsCount.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            viewsCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            viewsCount.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
