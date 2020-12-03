//
//  BaseCell.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/23.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell, ViewModelBindable {

    var viewModel: CellDataContainable? {
        didSet {
            didSetViewModel(viewModel)
        }
    }

    func didSetViewModel(_ viewModel: CellDataContainable?) {
        // Do Nothing
    }

}
