//
//  MemoDetailViewController.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/30.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!

    private var isEditMode: Bool = false {
        didSet {
            willchangeMode(isEditMode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = view.backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Text.edit.rawValue,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(editButtonTapped(_:)))
        isEditMode = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUDManager.shared.showFloatingView()
    }
}


extension MemoDetailViewController {

    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        isEditMode.toggle()
    }

    private func willchangeMode(_ isEditMode: Bool) {
        guard isEditMode else {
            titleTextField.isEnabled = false
            memoTextView.isEditable = false
            navigationItem.rightBarButtonItem?.title = Text.edit.rawValue
            HUDManager.shared.showFloatingView()
            return
        }

        titleTextField.isEnabled = true
        memoTextView.isEditable = true
        navigationItem.rightBarButtonItem?.title = Text.save.rawValue
        HUDManager.shared.hideFloatingView()
    }
}

extension MemoDetailViewController {

    enum Text: String {
        case edit = "Edit"
        case save = "Save"
    }

}
