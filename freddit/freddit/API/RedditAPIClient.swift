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
    
    func top(limit: Int, count: Int, page: Int?, resultBlock: @escaping APIClientResponseBlock)
}

enum APIError: Error {
    case invalidLimit
    case malformedURL
}

enum ResponseError: Error {
    case invalidResponse
}

class RedditAPIClient: APIClient {
    
    private let session = URLSession.shared
    private let basePath = "https://api.reddit.com/top"
    private var before: String?
    private var after: String?
    
    enum QueryParams: String {
        case limit
        case count
        case before
        case after
        
        func queryItem(value: String?) -> URLQueryItem {
            return URLQueryItem(name: self.rawValue, value: value)
        }
    }
    
    func top(limit: Int, count: Int, page: Int?, resultBlock: @escaping APIClientResponseBlock) {
        guard limit > 0 else {
            resultBlock(nil, APIError.invalidLimit)
            return
        }
        guard var urlComponents = URLComponents(string: basePath) else {
            resultBlock(nil, APIError.malformedURL )
            return
        }
        
        let queryItems: [URLQueryItem] = [
            QueryParams.limit.queryItem(value:"\(limit)"),
            QueryParams.count.queryItem(value: "\(count)"),
        ]
        
        if let page = page {
            let currentPage = count/limit
            
            if currentPage > page, let after = after {
                // Todo: fetch next page
            } else if currentPage < page, let before = before {
                // TODO: fetch previous
            }
        }
        
        urlComponents.queryItems = queryItems
        // first Page
        
        guard let url = urlComponents.url else {
            resultBlock(nil, APIError.malformedURL)
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Listing.self, from: data)
                    resultBlock(res,nil)
                } catch {
                    resultBlock(nil, error)
                }
            }
            }.resume()
    }
}


class MockClient: APIClient {
    
    private let waitTime: TimeInterval = 5
    func top(limit: Int, count: Int, page: Int?, resultBlock: @escaping APIClientResponseBlock) {
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
