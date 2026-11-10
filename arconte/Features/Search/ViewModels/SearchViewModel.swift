//
//  SearchViewModel.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class SearchViewModel {
    private let gameService: GameService
    
    private(set) var games: [Game] = []
    private(set) var isLoading = false
    private(set) var hasSearched = false
    private(set) var errorMessage: String?
    
    init(gameService: GameService? = nil) {
        self.gameService = gameService ?? GameService()
    }
    
    func searchGames(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            games = []
            hasSearched = false
            errorMessage = nil
            
            return
        }
        
        isLoading = true
        hasSearched = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let results = try await gameService.searchGames(query: trimmedQuery)
            
            try Task.checkCancellation()
            
            games = results
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearSearch() {
        games = []
        hasSearched = false
        errorMessage = nil
    }
}
