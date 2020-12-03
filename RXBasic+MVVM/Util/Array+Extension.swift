//
//  Array+Extension.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/23.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

public extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
