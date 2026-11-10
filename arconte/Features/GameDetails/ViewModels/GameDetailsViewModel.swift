//
//  GameDetailsViewModel.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class GameDetailsViewModel {
    private let gameService: GameService
    
    private(set) var game: Game?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(gameService: GameService? = nil) {
        self.gameService = gameService ?? GameService()
    }
    
    func loadGameDetails(id: Int) async {
        guard !isLoading else { return }
        
        if game?.id == id {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            game = try await gameService.fetchGameDetails(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
