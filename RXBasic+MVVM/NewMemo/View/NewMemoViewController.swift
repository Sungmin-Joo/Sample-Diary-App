//
//  NewMemoViewController.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/10/04.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxSwift

class NewMemoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!

    private let viewModel = NewMemoViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        // Memo 저장
        let title = titleTextField.text ?? ""
        let body = bodyTextView.text ?? ""
        viewModel.registMemo(title, body)
        dismiss(animated: true)
    }
}
