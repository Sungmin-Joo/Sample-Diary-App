//
//  UIView+Extension.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/26.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

extension UIView {
    var isDarkMode: Bool {
        guard #available(iOS 13.0, *) else {
            return false
        }

        return (UIScreen.main.traitCollection.userInterfaceStyle == .dark)
    }
}
