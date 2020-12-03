//
//  HomeViewController+SearchPhase.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxCocoa
import RxSwift

extension HomeViewController {

    func setupSearchData() {
        viewModel.searchResultCellModels
            .observeOn(MainScheduler.instance)
            .debug()
            .bind(to: searchResultTableView.rx.items(
                cellIdentifier: HomeConst.Identifier.memo.rawValue,
                cellType: MemoCell.self)) { _, item, cell in
                    cell.viewModel = item
        }
        .disposed(by: disposeBag)
    }

}

extension HomeViewController: SearchResultPresentable {

    // appear search View
    func searchWillStart() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.searchResultTableView.alpha = 1
        })
    }

    func searchResultWillChange(text: String) {
        viewModel.didChangeSearchText(text)
    }

    // hide search View
    func searchDidEnd() {
        viewModel.clearSearchResult()

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.searchResultTableView.alpha = 0
        })
    }

}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchWillStart()
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = .none
        searchDidEnd()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeSearchText(searchText)
    }
}
