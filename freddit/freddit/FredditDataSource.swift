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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.author
        return cell
    }
    
}
