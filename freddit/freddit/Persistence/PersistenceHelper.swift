//
//  PersistanceHelper.swift
//  freddit
//
//  Created by Francisco Gindre on 12/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import Foundation

protocol ReadItemTracking {
    static func markAsRead(item: ListingItem)
    static func isItemRead(_ item: ListingItem) -> Bool
}

/**
 this can be switched to a more advanced implementation if needed, like a file, or even Core Data
 */

struct PersistenceHelper: ReadItemTracking {
    
    static func markAsRead(item: ListingItem) {
        guard let itemKey = key(for: item) else {
            print("❌ FATAL ERROR: no permalink to build key from ")
            return
        }
        UserDefaults.standard.set(true, forKey: itemKey)
    }
    
    static func isItemRead(_ item: ListingItem) -> Bool {
        guard let itemKey = key(for: item) else {
            print("❌ FATAL ERROR: no permalink to build key from ")
            return false
        }
        
        return UserDefaults.standard.bool(forKey: itemKey)
    }
    
    private static func key(for item: ListingItem) -> String? {
        return item.permalink
    }
    
}
