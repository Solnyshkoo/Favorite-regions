import UIKit

protocol RegionCellDelegate: AnyObject {
    func likeActoin(row: Int)
}

final class RegionCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = "RegionCell"
    weak var delegate: RegionCellDelegate?
    private var row: Int?
    
    private let photo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let like: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "heart"))
        view.tintColor = .systemRed
        view.tag = 0
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        like.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLike)))
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Like Action

    @objc func selectLike(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.likeActoin(row: row ?? 0)
        if like.tag == 0 {
            like.image = UIImage(systemName: "heart.fill")
            like.tag = 1
        } else {
            like.image = UIImage(systemName: "heart")
            like.tag = 0
        }
    }

    // MARK: - Config

    func config(index: Int, info: RegionOverview, delegate: RegionCellDelegate) {
        row = index
        photo.image = info.view
        title.text = info.title
        self.delegate = delegate
        if info.isLike {
            like.image = UIImage(systemName: "heart.fill")
            like.tag = 1
        } else {
            like.image = UIImage(systemName: "heart")
            like.tag = 0
        }
    }
    
    // MARK: - Set up Cell

    private func setUpCell() {
        contentView.addSubview(photo)
        contentView.addSubview(title)
        contentView.addSubview(like)
        
        NSLayoutConstraint.activate([
            photo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            photo.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photo.heightAnchor.constraint(equalToConstant: 150),
            
            like.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -30),
            like.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 15),
            like.widthAnchor.constraint(equalToConstant: 30),
            like.heightAnchor.constraint(equalToConstant: 30),
            
            title.leadingAnchor.constraint(equalTo: photo.leadingAnchor, constant: 30),
            title.trailingAnchor.constraint(equalTo: like.leadingAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10),
            title.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
