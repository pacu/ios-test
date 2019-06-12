//
//  FredditDataSource.swift
//  freddit
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import Foundation
import UIKit

class FredditDataSource: NSObject, UITableViewDataSource {
    
    
    private let pageLimit: Int = 50
    
    private var client: APIClient
    private var items = [ListingItem]()
    
    private var currentPageNumber: Int = 0
    
    
    // TODO: PAGING
    private var nextPage: String?
    private var previousPage: String?
    
    init(apiClient: APIClient) {
        self.client = apiClient
    }
    
    func fetch(initial: Bool = true, completion: ((Bool) -> Void)?) {
        if initial {
            currentPageNumber = 0
        }
        client.top(limit: pageLimit, count: 0, page: nil) { (listing, error) in
            
            
            guard let listing = listing, let listingItems = ListingVisitor.listingItems(from: listing, of: "t3") else {
                completion?(false)
                return
            }
            
            self.items.append(contentsOf: listingItems)
            completion?(true)
        }
    }
    
    func item(for indexPath: IndexPath) -> ListingItem? {
        guard indexPath.row < items.count else { return nil }
        return items[indexPath.row]
    }
    
    func removeItem(at indexPath: IndexPath) {
        items.remove(at: indexPath.row)
    }
    
    // Mark: Table View Data Source conformance
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, delegate: ListingItemDelegate) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ListingItemTableViewCell else {
            print("❌ FATAL ERROR: LISTING CELL OFF WRONG TYPE AT: \(indexPath)")
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(for: item, unread: !PersistenceHelper.isItemRead(item), delegate: delegate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("❌ use tableView:cellForRowAt:delegate instead")
    }
    
}
