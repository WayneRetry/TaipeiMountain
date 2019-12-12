import UIKit

class StatusView: UIView {
    lazy var statusText: UILabel = createStatusText()
    lazy var actionButton: UIButton = createActionButton()
    let config: TMConfig
    
    init(config: TMConfig) {
        self.config = config
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [statusText, actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -30),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
        ])
    }
    
    private func createStatusText() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19, weight: .light)
        label.text = "在此查看並分享你的相片"
        return label
    }
    
    private func createActionButton() -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.borderColor = config.mainColor.cgColor
        button.setTitleColor(config.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("允許使用", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return button
    }
}
