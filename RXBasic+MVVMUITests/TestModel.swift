//
//  TestClass.swift
//  RXBasic+MVVMUITests
//
//  Created by Sungmin on 2020/09/28.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

struct MemoModel: Codable {
    let id: Int
    var savedDate: String
    var title: String
    var body: String
    var tag: [String]
    var isPinned: Bool
    var pinnedIndex: Int
}
