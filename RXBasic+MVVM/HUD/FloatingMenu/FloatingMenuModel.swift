//
//  FloatingMenuModel.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/27.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

enum FloatingMenuModel {

    enum Button {
        static let diameter: CGFloat = 45
        static let systemName: String = "square.and.pencil"

        static func shadowColor(_ isDarkMode: Bool) -> CGColor {
            if isDarkMode {
                return UIColor.lightGray.cgColor
            }
            return UIColor.black.cgColor
        }

        enum Margin {
            static let trailing: CGFloat = -32
            static let bottom: CGFloat = -32
            static let gap: CGFloat = 8
        }
    }

    enum ViewModel {
        struct FloatingView {
            let buttons: [UIButton]
            var numOfMenu: Int {
                buttons.count
            }
        }
    }
} 
