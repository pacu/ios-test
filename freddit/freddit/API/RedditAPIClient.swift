//
//  RedditAPIClient.swift
//  freddit
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import Foundation

typealias APIClientResponseBlock = (_ result: Listing?, _ error: Error?) -> Void

protocol APIClient {
    
    func top(limit: Int, count: Int, page: String?, resultBlock: @escaping APIClientResponseBlock)
}


public enum ResponseError: Error {
    case invalidResponse
}

class RedditAPIClient: APIClient {
    func top(limit: Int, count: Int, page: String?, resultBlock: @escaping APIClientResponseBlock) {
        
    }
    
    
    let basePath = "https://api.reddit.com/top"
    
}


class MockClient: APIClient {
    
    private let waitTime: TimeInterval = 5
    func top(limit: Int, count: Int, page: String?, resultBlock: @escaping APIClientResponseBlock) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                DispatchQueue.main.async {
                    resultBlock(nil,nil)
                }
                return
            }
            do {
                let response = try self.resultFromFile(name: "MockResponse.json")
                DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                    resultBlock(response,nil)
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                    resultBlock(nil,error)
                }
            }
        }
    }
    
    
    private func resultFromFile(name: String) throws -> Listing? {
        guard let path = Bundle(for: MockClient.self).path(forResource: name, ofType: nil) else {
            return nil
        }
        let url = URL(fileURLWithPath:  path)
        guard let data = try? Data(contentsOf: url) else {
            throw ResponseError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(Listing.self , from: data)
        } catch {
            throw error
        }
    }
}
