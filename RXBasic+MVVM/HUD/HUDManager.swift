//
//  HUDManager.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/25.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

final class HUDManager {

    static let shared = HUDManager()
    private init() {
        setFloatingView()
    }

    private let floatingView = FloatingView()

    private var window: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }

}

// MARK: - Setup
extension HUDManager {

    private func setFloatingView() {

        let newMemoImage = HomeConst.Image.newMemo.getImage()
        let newMemoButton = UIButton()
        newMemoButton.setImage(newMemoImage, for: .normal)
        newMemoButton.addTarget(self,
                                action: #selector(newMemoButtonTapped),
                                for: .touchUpInside)

        let newForderImage = HomeConst.Image.newFolder.getImage()
        let newForderButton = UIButton()
        newForderButton.setImage(newForderImage, for: .normal)
        newForderButton.addTarget(self,
                                  action: #selector(newForderButtonTapped),
                                  for: .touchUpInside)

        floatingView.translatesAutoresizingMaskIntoConstraints = false
        floatingView.childButtons = [newMemoButton, newForderButton]
        floatingView.alpha = 0

        layoutFloatingView()
    }

    private func layoutFloatingView() {
        guard let window = window else { return }

        window.addSubview(floatingView)

        NSLayoutConstraint.activate([
            floatingView.topAnchor.constraint(
                equalTo: window.topAnchor
            ),
            floatingView.bottomAnchor.constraint(
                equalTo: window.bottomAnchor
            ),
            floatingView.leadingAnchor.constraint(
                equalTo: window.leadingAnchor
            ),
            floatingView.trailingAnchor.constraint(
                equalTo: window.trailingAnchor
            )
        ])
    }

}

// MARK: - Public method
extension HUDManager {

    func showFloatingView() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.floatingView.alpha = 1
        })
    }

    func hideFloatingView() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.floatingView.alpha = 0
        })
    }

}

// MARK: - Button action
extension HUDManager {

    @objc func newMemoButtonTapped() {
        floatingView.floatingButton.isSelected.toggle()
        let vc = NewMemoViewController()

        guard let navigationVC = window?.rootViewController as? UINavigationController else {
            return
        }

        navigationVC.present(vc, animated: true)
//        navigationVC.pushViewController(vc, animated: true)
    }

    @objc func newForderButtonTapped() {
        floatingView.floatingButton.isSelected.toggle()

        let alert = UIAlertController(title: "New Folder",
                                      message: "input folder name",
                                      preferredStyle: .alert)
        let register = UIAlertAction(title: "Done", style: .default) { _ in
            let folderName = alert.textFields?.first?.text
            debugPrint(folderName)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField { textField in
            textField.placeholder = "ex) Swift Study"
        }


        alert.addAction(register)
        alert.addAction(cancel)

        window?.rootViewController?.present(alert, animated: true, completion: nil)

    }
}
