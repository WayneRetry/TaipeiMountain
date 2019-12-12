import UIKit
import Photos

class ImageSelectedView: UIView {
    
    lazy var labelView: UIView = createLabelView()
    lazy var countLabel: UILabel = createCountLabel()
    var config: TMConfig? {
        didSet {
            updateColor()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelect(_ index: Int) {
        countLabel.text = "\(index + 1)"
        layer.borderColor = config?.getImageCellSelectColor().cgColor
        labelView.backgroundColor = config?.getImageCellSelectColor()
        labelView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func resetSelect() {
        countLabel.text = ""
        layer.borderColor = UIColor.clear.cgColor
        labelView.backgroundColor = UIColor.clear
        labelView.layer.borderColor = config?.getImageCellBorderColor().cgColor
    }
    
    private func setLayout() {
        layer.borderWidth = 4
        layer.borderColor = UIColor.clear.cgColor
        addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 12),
            labelView.heightAnchor.constraint(equalToConstant: 24),
            labelView.widthAnchor.constraint(equalToConstant: 24),
            countLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 3),
            countLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -3),
            countLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 0)
        ])
    }
    
    private func updateColor() {
        labelView.layer.borderColor = config?.getImageCellBorderColor().cgColor
        countLabel.textColor = config?.getImageCellCountColor()
    }
    
    private func createLabelView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        return view
    }
    
    private func createCountLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        return label
    }
}

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
