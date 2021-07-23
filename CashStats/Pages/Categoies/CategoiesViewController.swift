//
//  CategoiesViewController.swift
//  CashStats
//
//  Created by GGsrvg on 29.06.2021.
//

import UIKit
import LDS
import DB

class CategoiesViewController: BaseViewController<CategoiesViewModel, EmptyDataInitViewController> {
    
    override class func initWith(_ data: EmptyDataInitViewController?) -> Self {
        return CategoiesViewController(viewModel: CategoiesViewModel()) as! Self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var adapter: UITableViewAdapter<String?, CategoryEntity, String?>!
    
    deinit {
        adapter?.observableDataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
        navigationItem.backButtonTitle = "Back"
        navigationItem.rightBarButtonItems = [
            .init(systemItem: .add, primaryAction: .init(title: "test") { action in
                let vc = AddCategoryViewController.initWith(nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }, menu: nil)
        ]
        
        adapter = .init(tableView)
        adapter.cellForRowHandler = { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath)
            
            if let cell = cell as? CategoryTableViewCell {
                cell.model = model
            }
            
            return cell
        }
        adapter.numberOfSectionsHandler = { _, _ in
            self.refreshControl.endRefreshing()
        }
        adapter.observableDataSource = viewModel.categories
        tableView.register(fromNib: CategoryTableViewCell.self)
        tableView.dataSource = adapter
        tableView.delegate = self
        
        refreshControl.addAction(.init(handler: { _ in
            self.viewModel.load()
        }), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

extension CategoiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.viewModel.categories.array[indexPath.row]
        
        self.navigationController?.pushViewController(
            ConsumptionListViewController.initWith(
                ConsumptionListDataInitViewController(category: entity)
            ),
            animated: true
        )
    }
}
