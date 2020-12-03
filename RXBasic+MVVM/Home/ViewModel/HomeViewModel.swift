
//
//  HomeViewModel.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxSwift

final class HomeViewModel: ViewDataContainable {

    enum HomeSectionType: Int, CaseIterable {
        case pinned
        case list
    }

    private var cellModels: [HomeSectionType: [CellDataContainable]] = [:]
    private var preSearchData: String?
    private var disposeBag = DisposeBag()

    let searchResultCellModels = BehaviorSubject<[MemoCellModel]>(value: [])
    let memoListObservable = BehaviorSubject<[MemoCellModel]>(value: [])
    var didFetchViewData: (() -> Void)?

    init() {
        setupObservable()
    }

    private func setupObservable() {
        MemoDBManager.shared.memoObservable
            .subscribe(onNext: { memoList in
                self.configureMemoList(memoList)
            })
            .disposed(by: disposeBag)
    }

    private func configureMemoList(_ list: [MemoModel]) {
        cellModels[.list] = list.map { MemoCellModel(text: $0.title) }

        cellModels[.pinned] = list.filter { $0.isPinned }
            .map { MemoCellModel(text: $0.title) }

        didFetchViewData?()
    }

}

extension HomeViewModel: ListDataContainable {

    var numberOfSections: Int {
        return HomeSectionType.allCases.count
    }


    func titleForSection(_ section: Int) -> String? {
        guard let sectionType = HomeSectionType.init(rawValue: section) else {
            return .none
        }

        switch sectionType {
        case .pinned:
            return "Pinned"
        case .list:
            return "Memo"
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let sectionType = HomeSectionType.init(rawValue: section) else {
            return 0
        }

        return cellModels[sectionType]?.count ?? 0
    }

    func cellModelForRowAt(_ indexPath: IndexPath) -> CellDataContainable? {
        guard
            let sectionType = HomeSectionType.init(rawValue: indexPath.section) else {
                return nil
        }

        return cellModels[sectionType]?[safe: indexPath.row]
    }
}

extension HomeViewModel: SearchDataContainable {

    func clearSearchResult() {
        searchResultCellModels.onNext([])
    }

    func didChangeSearchText(_ text: String) {
        let searchText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard preSearchData != searchText else {
            return
        }
        preSearchData = searchText

        // 태그와 제목 검색
        // 결과 데이터는 시간순 정렬
        do {
            let MemoModels = try MemoDBManager.shared.memoObservable.value()

            let searchResult = MemoModels.filter {
                $0.title.lowercased().components(separatedBy: " ").contains(find: searchText)
            }.sorted { $0 < $1 }


            // 추후 set 사용하여 통합
            let tagResult = MemoModels
                .filter { $0.tag.map { $0.lowercased() }.contains(find: searchText) }
                .sorted { $0 < $1 }


            searchResultCellModels.onNext(
                searchResult.map { MemoCellModel(text: $0.title) }
            )
        } catch {
            Logger.log("memoObservable Error", error, level: .error)
        }

    }
}

private extension BidirectionalCollection where Element: StringProtocol {

    func contains(find: Element) -> Bool {

        for word in self {
            if (word.range(of: find) != nil) {
                return true
            }
        }

        return false
    }

}
