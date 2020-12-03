//
//  Protocols.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/23.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxSwift

// TODO: - ViewModel 프로토콜 이름 개선
protocol ViewDataContainable {
    var searchResultCellModels: BehaviorSubject<[MemoCellModel]>{ get }
    var didFetchViewData: (() -> Void)? { get set }
}

protocol ListDataContainable {
    var numberOfSections: Int { get }
    func titleForSection(_ section: Int) -> String?
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellModelForRowAt(_ indexPath: IndexPath) -> CellDataContainable?
}

protocol SearchDataContainable {
    func clearSearchResult()
    func didChangeSearchText(_ text: String)
}

// TODO: - CellViewModel 프로토콜 이름 개선
protocol CellDataContainable {
    var reuseIdentifier: String { get }
}

// TODO: - ViewModel을 가질 수 있는 프로토콜 이름 개선
protocol ViewModelBindable {
    var viewModel: CellDataContainable? { get set }
    func didSetViewModel(_ viewModel: CellDataContainable?)
}

// DB Storable protocol
protocol Storable {
    var tableName: String { get }

    var createQuery: String { get }
    var readQuery: String { get }
    var insertQuery: String { get }
    var updateQuery: String { get }
    var truncateQuery: String { get }
    var deleteQuery: String { get }
}
