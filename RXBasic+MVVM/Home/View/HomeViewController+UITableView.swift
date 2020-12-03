//
//  HomeViewController+UITableView.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = MemoDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cellModel = viewModel.cellModelForRowAt(indexPath) else {
            let dqCell = tableView.dequeueReusableCell(
                withIdentifier: HomeConst.Identifier.base.rawValue,
                for: indexPath
            )
            return dqCell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellModel.reuseIdentifier,
            for: indexPath
        )

        if let memoCell = cell as? MemoCell {
            memoCell.viewModel = cellModel
        }

        return cell
    }

    
}
