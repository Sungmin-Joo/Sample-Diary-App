//
//  NewMemoViewModel.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/10/04.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

class NewMemoViewModel {
    func registMemo(_ title: String, _ body: String) {
        MemoDBManager.shared.insert(
            title: title,
            body: body,
            tag: ["123", "456"],
            isPinned: false,
            pinnedIndex: -1
        )
    }
}
