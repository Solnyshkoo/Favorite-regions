import UIKit

final class RegionPhotoCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = "RegionPhotoCell"
    
    private let photo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func config(view: UIImage) {
        photo.image = view
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up cell

    private func setupCell() {
        contentView.addSubview(photo)
        NSLayoutConstraint.activate([
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor),
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
}
