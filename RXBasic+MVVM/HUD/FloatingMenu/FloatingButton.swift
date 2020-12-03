//
//  FloatingButton.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/25.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

protocol FloatingButtonDelegate: AnyObject {
    func show()
    func hide()
}

final class FloatingButton: UIButton {

    weak var delegate: FloatingButtonDelegate?

    override var isSelected: Bool {
        didSet {
            guard isSelected else {
                hide()
                return
            }
            show()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        setupButton()
    }


}

// MARK: - Action
extension FloatingButton {

    @objc private func buttonDidTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }

    private func show() {
        delegate?.show()
    }

    private func hide() {
        delegate?.hide()
    }
}

// MARK: - Setup
extension FloatingButton {
    private func setupButton() {
        let buttonImage = UIImage(systemName: FloatingMenuModel.Button.systemName)
        setImage(buttonImage, for: .normal)
        tintColor = .white
        backgroundColor = .darkGray
        layer.cornerRadius = FloatingMenuModel.Button.diameter * 0.5
        layer.shadowColor = FloatingMenuModel.Button.shadowColor(isDarkMode)
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.masksToBounds = false

        addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
    }
}
