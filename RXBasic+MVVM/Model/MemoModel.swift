//
//  MemoModel.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

struct MemoModel: Codable, Hashable {
    let id: Int
    var updateDate: Date
    var title: String
    var body: String
    var tag: [String]
    var isPinned: Bool
    var pinnedIndex: Int
}

extension MemoModel: Comparable {
    static func < (lhs: MemoModel, rhs: MemoModel) -> Bool {
        let lhsData = lhs.updateDate
        let rhsData = rhs.updateDate

        return lhsData.compare(rhsData) == ComparisonResult.orderedDescending
    }
}
