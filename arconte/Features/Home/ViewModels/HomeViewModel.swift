//
//  HomeViewModel.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let gameService: GameService
    
    private(set) var games: [Game] = []
    private(set) var featuredGame: Game?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(gameService: GameService? = nil) {
        self.gameService = gameService ?? GameService()
    }
    
    func loadPopularGames() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            games = try await gameService.fetchPopularGames()
            
            guard let firstGame = games.last else {
                featuredGame = nil
                return
            }
            
            do {
                featuredGame = try await gameService.fetchGameDetails(id: firstGame.id)
            } catch {
                featuredGame = firstGame
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
