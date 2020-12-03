//
//  NSObject+Extension.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/23.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
