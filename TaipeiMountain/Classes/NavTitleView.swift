import UIKit

protocol NavTitleViewDelegate: class {
    func navigationTitlePress()
}

class NavTitleView: UIView {
    weak var delegate: NavTitleViewDelegate?
    lazy private var titleLabel: UILabel = createTitleLabel()
    lazy private var subtitleLabel: UILabel = createSubtitleLabel()
    lazy private var touchButton: UIButton = createButton()
    
    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(touchButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title:String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        titleLabel.frame.origin.x = 0
        subtitleLabel.frame.origin.x = 0
        
        titleLabel.frame.size.width = min(titleLabel.frame.size.width, 200)
        
        frame = CGRect(x:0, y:0, width:max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height:30)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
            touchButton.frame = CGRect(origin: .zero, size: CGSize(width: titleLabel.frame.size.width + 10, height: 40))
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
            touchButton.frame = CGRect(origin: .zero, size: CGSize(width: subtitleLabel.frame.size.width + 10, height: 40))
        }
        
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x:0, y:-2, width:0, height:0))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.lineBreakMode = .byTruncatingMiddle
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }
    
    private func createSubtitleLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x:0, y:20, width:0, height:0))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "點按這邊以變更"
        return label
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonPressDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonPressUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressUpOutside), for: .touchUpOutside)
        return button
    }
    
    @objc func buttonPressDown() {
        UIView.transition(with: titleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.titleLabel.textColor = UIColor.gray
        }, completion: nil)
        UIView.transition(with: subtitleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.subtitleLabel.textColor = UIColor.gray
        }, completion: nil)
    }
    
    @objc func buttonPressUpInside() {
        UIView.transition(with: titleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.titleLabel.textColor = UIColor.black
        }, completion: nil)
        UIView.transition(with: subtitleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.subtitleLabel.textColor = UIColor.black
        }, completion: nil)
        delegate?.navigationTitlePress()
    }
    
    @objc func buttonPressUpOutside() {
        UIView.transition(with: titleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.titleLabel.textColor = UIColor.black
        }, completion: nil)
        UIView.transition(with: subtitleLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            [weak self] in
            self?.subtitleLabel.textColor = UIColor.black
        }, completion: nil)
    }
}
