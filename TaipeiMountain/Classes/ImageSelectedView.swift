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
