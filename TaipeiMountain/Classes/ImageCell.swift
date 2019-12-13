import UIKit
import Photos

class ImageCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String = ""
    var config: TMConfig? {
        didSet {
            updateColor()
        }
    }
    lazy var imageView: UIImageView = createImageView()
    lazy var highlightOverlay: UIView = createHighlightOverlay()
    lazy var selectedView: ImageSelectedView = createSelectedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightOverlay.isHidden = !isHighlighted
            if isHighlighted {
                imageView.transform = CGAffineTransform.identity
            } else {
                imageView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setLayout() {
        clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highlightOverlay)
        highlightOverlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            topAnchor.constraint(equalTo: highlightOverlay.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: highlightOverlay.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: highlightOverlay.trailingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: highlightOverlay.bottomAnchor, constant: 0),
            topAnchor.constraint(equalTo: selectedView.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: selectedView.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: selectedView.trailingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: 0),
        ])
    }
    
    private func updateColor() {
        selectedView.config = config
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        return imageView
    }
    
    private func createHighlightOverlay() -> UIView {
        let overlayView = UIView()
        overlayView.isHidden = true
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return overlayView
    }
    
    private func createSelectedView() -> ImageSelectedView {
        let selectedView = ImageSelectedView()
        return selectedView
    }
}
