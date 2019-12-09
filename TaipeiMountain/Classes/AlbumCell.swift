import UIKit

class AlbumCell: UITableViewCell {
    
    lazy var albumImageView: UIImageView = createAlbumImageView()
    lazy var albumNameLabel: UILabel = createAlbumNameLabel()
    lazy var photosCountLabel: UILabel = createPhotosCountLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        clipsToBounds = true
        addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(albumNameLabel)
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photosCountLabel)
        photosCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 6),
            albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor, multiplier: 1),
            albumNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: albumNameLabel.trailingAnchor, constant: 8),
            photosCountLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 2),
            photosCountLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: photosCountLabel.trailingAnchor, constant: 8),
        ])
    }
    
    private func createAlbumImageView() -> UIImageView {
        let albumImageView = UIImageView()
        albumImageView.clipsToBounds = true
        albumImageView.contentMode = .scaleAspectFill
        return albumImageView
    }
    
    private func createAlbumNameLabel() -> UILabel {
        let albumNameLabel = UILabel()
        albumNameLabel.font = UIFont.systemFont(ofSize: 15)
        albumNameLabel.textColor = Config.Style.AlbumCell.nameColor
        return albumNameLabel
    }
    
    private func createPhotosCountLabel() -> UILabel {
        let photosCountLabel = UILabel()
        photosCountLabel.font = UIFont.systemFont(ofSize: 13)
        photosCountLabel.textColor = Config.Style.AlbumCell.countColor
        return photosCountLabel
    }
    
}
