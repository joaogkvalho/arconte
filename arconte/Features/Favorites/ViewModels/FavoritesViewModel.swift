//
//  FavoritesViewModel.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class FavoritesViewModel {
    private let modelContext: ModelContext
    
    private(set) var favorites: [FavoriteGame] = []
    private(set) var errorMessage: String?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadFavorites()
    }
    
    func loadFavorites() {
        let descriptor = FetchDescriptor<FavoriteGame>(
            sortBy: [
                SortDescriptor(\.addedAt, order: .reverse)
            ]
        )
        
        do {
            favorites = try modelContext.fetch(descriptor)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func isFavorite(gameID: Int) -> Bool {
        favorites.contains { $0.gameID == gameID }
    }
    
    func toggleFavorite(_ game: Game) {
        if let favorite = favorites.first(where: {
            $0.gameID == game.id
        }) {
            modelContext.delete(favorite)
        } else {
            let favorite = FavoriteGame(
                gameID: game.id,
                name: game.name,
                coverURL: game.cover?.url,
                rating: game.rating
            )
            
            modelContext.insert(favorite)
        }
        
        do {
            try modelContext.save()
            loadFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
