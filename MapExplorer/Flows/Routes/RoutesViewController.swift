//
//  RoutesViewController.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources
import RealmSwift

protocol RoutesDelegate: AnyObject {
    func showSelectedRoute(locations: [Location])
}

/// Экран сохраненнных маршрутов
class RoutesViewController: UIViewController, View {
    
    weak var delegate: RoutesDelegate?
    var disposeBag = DisposeBag()

    private let customView = RoutesView(frame: UIScreen.main.bounds)
    private var routes: [Route]
    private var viewModel: RoutesViewModel
    
    // MARK: - Inits
    
    init(routes: [Route], viewModel: RoutesViewModel) {
        self.routes = routes
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = customView
        customView.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.Routes.title
        reactor = viewModel
    }
    
    // MARK: - Public methods
    
    func bind(reactor: RoutesViewModel) {
        let dataSource = RxTableViewSectionedReloadDataSource<RowOfRouteData>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: RoutesView.Cell.reuseId, for: indexPath)
              cell.textLabel?.text = item.title
            return cell
        })
        
        reactor.state
            .map { $0.rows }
            .bind(to: customView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // Признак ошибки
        reactor.state
            .filter { $0.isError }
            .map { $0.isError }
            .bind { [weak self] _ in
                self?.customView.setError()
            }
            .disposed(by: disposeBag)
        
        // Тап по ячейке таблицы
        customView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let route = self.routes[indexPath.row]
                self.delegate?.showSelectedRoute(locations: route.locations.toArray())
            })
            .disposed(by: disposeBag)
        
        reactor.action.onNext(.routes(routes))
    }
}
