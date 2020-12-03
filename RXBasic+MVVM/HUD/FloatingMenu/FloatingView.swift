//
//  FloatingView.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/26.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

class FloatingView: UIView {
    
    typealias ViewModelType = FloatingMenuModel.ViewModel.FloatingView
    
    let floatingButton: FloatingButton = {
        let button = FloatingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dimmedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isShowing: Bool = false
    private var showAfterSetButtons: Bool = false
    private var btnsBottomConstraints: [NSLayoutConstraint]?
    private var buttons: [UIButton]? {
        didSet {
            setButtonsConstraints()
        }
    }
    
    /// If menuButtons = [a, b, c]
    /// top button = a
    /// bottom button = c
    var childButtons: [UIButton]? {
        set {
            buttons = newValue?.reversed()
        }
        get {
            buttons
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    convenience init() {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // configure event
    // if isShowing => entire view
    // if not => only floatingButton
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isShowing else {
            
            if floatingButton.frame.contains(point) {
                return super.hitTest(point, with: event)
            }
            
            return nil
        }
        return super.hitTest(point, with: event)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            floatingButton.layer.shadowColor = FloatingMenuModel.Button.shadowColor(isDarkMode)
            buttons?.forEach {
                $0.layer.shadowColor = FloatingMenuModel.Button.shadowColor(isDarkMode)
            }
        }
    }
    
    private func initialize() {
        floatingButton.delegate = self
        
        dimmedButton.addTarget(self,
                               action: #selector(dimmedButtonTapped(_:)),
                               for: .touchUpInside)
        
        addSubview(dimmedButton)
        addSubview(floatingButton)
        
        setConstraint()
    }

}

// MARK: - Delegate & Animation
extension FloatingView: FloatingButtonDelegate {
    
    private func prepareForAnimation() {
        dimmedButton.isHidden = false
        buttons?.forEach {
            $0.alpha = 0
            $0.isHidden = false
        }
        btnsBottomConstraints?.forEach {
            $0.constant = FloatingMenuModel.Button.Margin.bottom
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.dimmedButton.alpha = 0.5
        })
    }
    
    func show() {
        guard !isShowing else { return }
        isShowing = true
        
        prepareForAnimation()
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.buttons?.forEach { $0.alpha = 1 }
                self.btnsBottomConstraints?
                    .enumerated()
                    .forEach { (index, constraint) in
                        let weight = CGFloat(index + 1)
                        let diameter = FloatingMenuModel.Button.diameter
                        let gap = FloatingMenuModel.Button.Margin.gap
                        constraint.constant -= weight * (diameter + gap)
                }
                
                self.layoutIfNeeded()
        })
    }
    
    func hide() {
        guard isShowing else { return }
        isShowing = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.dimmedButton.alpha = 0
                self.buttons?.forEach { $0.alpha = 0 }
                self.btnsBottomConstraints?.forEach {
                    $0.constant = FloatingMenuModel.Button.Margin.bottom
                }
                self.layoutIfNeeded()
        }, completion: { _ in
            self.buttons?.forEach { $0.isHidden = true }
            self.dimmedButton.isHidden = true
            
        })
    }
}

// MARK: - Constraints
extension FloatingView {
    
    private func setButtonsConstraints() {
        
        defer {
            if showAfterSetButtons {
                show()
            }
        }
        
        if isShowing {
            hide()
            showAfterSetButtons = true
        }
        
        btnsBottomConstraints = []
        
        buttons?.enumerated().forEach({ (index, button) in
            
            button.isHidden = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .white
            button.backgroundColor = .darkGray
            button.layer.cornerRadius = FloatingMenuModel.Button.diameter * 0.5
            button.layer.shadowColor = FloatingMenuModel.Button.shadowColor(isDarkMode)
            button.layer.shadowOpacity = 0.7
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
            button.layer.masksToBounds = false
            
            addSubview(button)
            
            btnsBottomConstraints?.append(
                button.bottomAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor,
                    constant: FloatingMenuModel.Button.Margin.bottom
                )
            )
            
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: FloatingMenuModel.Button.Margin.trailing
                ),
                button.widthAnchor.constraint(
                    equalToConstant: FloatingMenuModel.Button.diameter
                ),
                button.heightAnchor.constraint(
                    equalToConstant: FloatingMenuModel.Button.diameter
                )
            ])
        })
        
        btnsBottomConstraints?.forEach { $0.isActive = true }
    }
    
    private func setConstraint() {
        
        NSLayoutConstraint.activate([
            
            // floatingButton
            floatingButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: FloatingMenuModel.Button.Margin.trailing
            ),
            floatingButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: FloatingMenuModel.Button.Margin.bottom
            ),
            floatingButton.widthAnchor.constraint(
                equalToConstant: FloatingMenuModel.Button.diameter
            ),
            floatingButton.heightAnchor.constraint(
                equalToConstant: FloatingMenuModel.Button.diameter
            ),
            
            // dimmedButton
            dimmedButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -100
            ),
            dimmedButton.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            dimmedButton.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            dimmedButton.trailingAnchor.constraint(
                equalTo: trailingAnchor
            )
        ])
    }
}

// MARK: - Action
extension FloatingView {
    @objc func dimmedButtonTapped(_ sender: UIButton) {
        floatingButton.isSelected = false
    }
}
