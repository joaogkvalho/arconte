//
//  FavoriteButton.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI
import SwiftData

struct FavoriteButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteGame]
    
    let game: Game
    
    @State private var showingError = false
    
    private var isFavorite: Bool {
        favorites.contains { $0.gameID == game.id }
    }
    
    var body: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(
                    isFavorite
                        ? Color.arcontePurple
                        : Color.arconteTextPrimary
                )
                .frame(width: 46, height: 46)
                .background(Color.arconteElevated.opacity(0.9))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        .alert("Something went wrong", isPresented: $showingError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("The favorite could not be saved. Please try again")
        }
    }
    
    private func toggleFavorite() {
        if let favorite = favorites.first(where: {
            $0.gameID == game.id
        }) {
            modelContext.delete(favorite)
        } else {
            modelContext.insert(
                FavoriteGame(
                    gameID: game.id,
                    name: game.name,
                    coverURL: game.cover?.url,
                    rating: game.rating
                )
            )
        }
        
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            showingError = true
        }
    }
}
