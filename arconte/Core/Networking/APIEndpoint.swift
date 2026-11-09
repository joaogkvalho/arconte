//
//  APIEndpoint.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import Foundation

enum APIEndpoint {
    case popularGames(offset: Int)
    case searchGames(query: String, offset: Int)
    case gameDetails(id: Int)
    
    var path: String {
        switch self {
        case .popularGames, .searchGames:
            return "/games"
            
        case .gameDetails(let id):
            return "games/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popularGames(let offset):
            return [
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            
        case .searchGames(let query, let offset):
            return [
                URLQueryItem(name: "search", value: query),
                URLQueryItem(name: "offset", value: "\(offset)"),
            ]
            
        case .gameDetails:
            return []
        }
    }
}
