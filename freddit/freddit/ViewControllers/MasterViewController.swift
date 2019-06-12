//
//  MasterViewController.swift
//  freddit
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var dataSource = FredditDataSource(apiClient: RedditAPIClient())
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBlackBarTheme()
        setupToolbar()
        self.title = "Reddit Posts"

        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "reaching Narwhal HQ", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white ])
        self.refreshControl = refreshControl
        

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        fetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Data
    private func fetch() {
        dataSource.fetch { [weak self] (success) in
            DispatchQueue.main.async {
                
                guard success else {
                    print("Ooops fetch failed")
                    return
                }
                
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let object = dataSource.item(for: indexPath) else {
                    print("❌ERROR: Inexistent item pressed")
                    return
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: UI
    
    
    private func setupToolbar() {
        
        guard let nav = self.navigationController else { return }
        nav.isToolbarHidden = false
        nav.toolbar.barStyle = UIBarStyle.blackTranslucent
        nav.toolbar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let dismissAll = UIBarButtonItem(title: "Dismiss All", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissAll(_:)))
        
        dismissAll.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        
        let items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            dismissAll,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        ]
        self.setToolbarItems(items, animated: false)
    }

    // MARK: - Table View Data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections(in: tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAt: indexPath, delegate: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }

    // MARK: events
    @objc func refresh(_ sender: Any) {
       fetch()
    }
    
    @objc func dismissAll(_ sender: Any?) {
       dataSource.removeAllItems(from: tableView)
    }
    

}

extension MasterViewController: ListingItemDelegate {
    func dismissed(cell: ListingItemTableViewCell, item: ListingItem) {
        // todo: hook this up to set up how posts are persisted read
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("❌ error: could not remove item")
            return
        }
        dataSource.removeItem(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
}
