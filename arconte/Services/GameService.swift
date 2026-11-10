//
//  GameService.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import Foundation

struct GameService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchPopularGames(offset: Int = 0) async throws -> [Game] {
        try await apiClient.request(.popularGames(offset: offset))
    }
    
    func searchGames(query: String, offset: Int = 0) async throws -> [Game] {
        try await apiClient.request(.searchGames(query: query, offset: offset))
    }
    
    func fetchGameDetails(id: Int) async throws -> Game {
        try await apiClient.request(.gameDetails(id: id))
    }
}
