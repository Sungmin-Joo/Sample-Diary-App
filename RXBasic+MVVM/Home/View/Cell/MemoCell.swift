//
//  ContentCell.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

class MemoCell: BaseCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = HomeConst.Font.textFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = .none
    }

    override func didSetViewModel(_ viewModel: CellDataContainable?) {
        super.didSetViewModel(viewModel)

        guard let viewModel = viewModel as? MemoCellModel else { return }
        titleLabel.text = viewModel.text
    }

    private func initialize() {

        contentView.addSubview(titleLabel)

        let layoutGuide = contentView.safeAreaLayoutGuide

        // 혹시나 타이틀이 없는 메뉴가 들어왔을 경우를 대비하여 최소 label 크기를 정의
        let textLavelHeight = titleLabel.heightAnchor.constraint(
            equalToConstant: HomeConst.Height.textLabel
        )
        textLavelHeight.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            textLavelHeight,
            titleLabel.topAnchor.constraint(
                equalTo: layoutGuide.topAnchor,
                constant: 8
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: layoutGuide.bottomAnchor,
                constant: -8
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor,
                constant: 8
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor,
                constant: -8
            )

        ])
    }
}

struct MemoCellModel: CellDataContainable {
    let text: String

    var reuseIdentifier: String {
        MemoCell.className
    }
}
