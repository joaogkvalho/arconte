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
    private var activeRequestID: UUID?
    
    private(set) var game: Game?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(gameService: GameService? = nil) {
        self.gameService = gameService ?? GameService()
    }
    
    func loadGameDetails(id: Int) async {
        guard game?.id != id else { return }

        let requestID = UUID()
        activeRequestID = requestID

        isLoading = true
        game = nil
        errorMessage = nil

        defer {
            if activeRequestID == requestID {
                isLoading = false
            }
        }

        do {
            let result = try await gameService.fetchGameDetails(id: id)

            try Task.checkCancellation()

            guard activeRequestID == requestID else { return }

            game = result

        } catch is CancellationError {
            return

        } catch {
            guard activeRequestID == requestID else { return }

            errorMessage = error.localizedDescription
        }
    }
}
