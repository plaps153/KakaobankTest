//
//  ViewController.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/22.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    let model = ViewModel()
    let searchVC = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "검색"
        self.tableView.showsVerticalScrollIndicator = false
        
        configureSearchBar()

        // Bind searchBar with searchedText relay
        self.searchVC.searchBar.rx.text.orEmpty.bind(to: model.searchedTextRelay).disposed(by: self.disposeBag)

        // Bind cancel button clicked event
        self.searchVC.searchBar.rx.cancelButtonClicked.asDriver().drive(onNext: { [weak self] (_) in
            self?.model.searchedTextRelay.accept("")
        }).disposed(by: self.disposeBag)

        // Bind search button clicked event
        let o1 = self.searchVC.searchBar.rx.searchButtonClicked.asObservable()
            .flatMap { [weak self] (_) -> Single<[SearchResult]> in
                guard let term = self?.searchVC.searchBar.text else {
                    return Single.error(NSError(domain: "Failed to get search test", code: 0, userInfo: nil))
                }

                // Save searched text in local
                self?.model.setSearchedText(with: term)

                return NetworkManager.default.searchRequest(with: term)
        }.flatMap { (results) -> Observable<[SearchResult]> in
            return Parser.getResultAsset(with: results)
        }
        .map { $0 as [Any] }

        // Bind text search results
        // Search result comes from the 'data'
        let o2 = model.data.asObservable().map { $0 as [Any] }

        // Bind tableview cell touch event
        let o3 = self.tableView.rx.itemSelected.map { (indexPath) -> String in
            if self.tableView.cellForRow(at: indexPath)?.reuseIdentifier == R.reuseIdentifier.searchResult.identifier {
                return self.tableView.cellForRow(at: indexPath)!.textLabel?.text ?? ""
            } else {
                self.performSegue(withIdentifier: R.segue.viewController.showResultViewController.identifier, sender: indexPath)
                return ""
            }
        }.filter { (string) -> Bool in
            return string.count > 0
        }.map {
            self.searchVC.searchBar.text = $0
            self.searchVC.searchBar.endEditing(true)
            return $0
        }.flatMap { (term) -> Single<[SearchResult]> in
            return NetworkManager.default.searchRequest(with: term)
        }.flatMap { (results) -> Observable<[SearchResult]> in
            return Parser.getResultAsset(with: results)
        }.map { $0 as [Any] }

        // Observe all event to show on the tableview
        Observable.merge([o1, o2, o3])
            .bind(to:tableView.rx.items) { (tableView, row, data) in
                let indexPath = IndexPath(row: row, section: 0)
                if let result = data as? SearchResult {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResultDetail.identifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
                    cell.setup(with: result)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchResult.identifier, for: indexPath)
                    guard let result = data as? String else { return UITableViewCell() }
                    cell.textLabel?.text = result
                    cell.selectionStyle = .none
                    return cell
                }
        }
        .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ResultViewController,
            let indexPath = sender as? IndexPath,
            let cell = self.tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell {
            dest.result = cell.result
        }
    }

    func configureSearchBar() {
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.showsCancelButton = false
        searchVC.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchVC.hidesNavigationBarDuringPresentation = true

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = self.searchVC
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.automaticallyShowsCancelButton = true
        definesPresentationContext = true
    }
}
