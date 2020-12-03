//
//  ViewController.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxSwift

protocol SearchResultPresentable {
    /// 검색 시작 전 검색결과 TableView 노출
    func searchWillStart() -> Void
    /// 검색 종료 후 검색결과 TableView 숨기고 메인 CollectionView 노출
    func searchDidEnd() -> Void
}

// MARK: - 현재 검색 결과 까지는 RX사용
final class HomeViewController: UIViewController {
    typealias ViewModelType = ViewDataContainable & ListDataContainable & SearchDataContainable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchResultTableView: UITableView!

    let disposeBag = DisposeBag()
    var viewModel: ViewModelType = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupCompletion()
        setupSearchData()
        HUDManager.shared.showFloatingView()
    }
}

// MARK: - Setup
extension HomeViewController {

    private func setupNavigationBar() {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = HomeConst.Text.search.rawValue
        searchBar.delegate = self
        searchBar.showsCancelButton = false

        navigationItem.titleView = searchBar

        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView
            .register(MemoCell.self, forCellReuseIdentifier: HomeConst.Identifier.memo.rawValue)
        tableView
            .register(BaseCell.self, forCellReuseIdentifier: HomeConst.Identifier.base.rawValue)

        searchResultTableView
            .register(MemoCell.self,forCellReuseIdentifier: HomeConst.Identifier.memo.rawValue)
    }

    private func setupCompletion() {

        viewModel.didFetchViewData = { [weak self] in
            self?.tableView.reloadData()
        }

    }
}

// MARK: - Constant
enum HomeConst {

    enum Font {
        static let textFont: UIFont = .systemFont(ofSize: 19, weight: .regular)
    }

    enum Height {
        static let textLabel: CGFloat = 19.0
    }

    enum Text: String {
        case search = "Search"
    }

    enum Identifier: String {
        case base = "Base"
        case memo = "MemoCell"
    }

    enum Image: CaseIterable {
        case newMemo
        case newFolder

        func getImage() -> UIImage? {
            switch self {
            case .newMemo:
                return UIImage(systemName: "pencil")
            case .newFolder:
                return UIImage(systemName: "folder.badge.plus")
            }
        }
    }
}
