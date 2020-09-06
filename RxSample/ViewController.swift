//
//  ViewController.swift
//  RxSample
//
//  Created by 김소은 on 2020/09/06.
//  Copyright © 2020 김소은. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    let allCities: [String] = ["New York", "London", "Oslo", "Warsaw", "berlin", "Praga"]
    lazy var shownCities: BehaviorSubject<[String]> = .init(value: allCities)
    var disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        shownCities.bind(to: tableView.rx.items(cellIdentifier: "cityPrototypeCell")) { (row, city, cell) in
            cell.textLabel?.text = city
        }.disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .compactMap { [weak self] query in self?.allCities.filter{ $0.hasPrefix(query) } }
            .bind(to: shownCities)
            .disposed(by: disposeBag)
    }
}
