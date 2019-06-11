//
//  Listing.swift
//  freddit
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import Foundation


struct ListingVisitor {
    static func listingItems(from listing: Listing, of kind: String) -> [ListingItem]? {
        guard let items = listing.data?.children else {
            return nil
        }
        
        
        return items.compactMap { (listingChild) -> ListingItem? in
            guard let childKind = listingChild.kind, childKind == kind else { return nil }
            
            return listingChild.data
        }
    }
}
struct Listing: Decodable {
    enum CodingKeys: CodingKey {
        case kind
        case data
    }
    
    var kind: String?
    var data: ListingData?
}

struct ListingData: Decodable {
    enum CodingKeys: String, CodingKey {
        case children
        case dist
        case after
        case before
    }
    
    var dist: Int?
    var children: [ListingChildren]?
    var after: String?
    var before: String?
    
}

struct ListingChildren: Decodable {
    enum CodingKeys: String, CodingKey {
        case kind
        case data
    }
    
    var kind: String?
    var data: ListingItem?
}


struct ListingItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case author
        case thumbnail
        case title
        case created = "created_utc"
        case comments = "num_comments"
    }
    
    var author: String?
    var thumbnail: String?
    var title: String?
    var created: TimeInterval?
    var comments: Int?

}
