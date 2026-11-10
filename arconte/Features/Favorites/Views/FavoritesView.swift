//
//  FavoritesView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI
import SwiftData

@MainActor
struct FavoritesView: View {
    @Query(sort: \FavoriteGame.addedAt, order: .reverse)
    private var favorites: [FavoriteGame]
    
    private let columns = [
        GridItem(.flexible(), spacing: 14, alignment: .top),
        GridItem(.flexible(), spacing: 14, alignment: .top),
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                header
                favoritesContent(favorites)
            }
            .padding(.top, 12)
            .background(Color.arconteBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .preferredColorScheme(.dark)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your Library")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)
            
            Text("Your favorite games, all in one place.")
                .font(.system(size: 14))
                .foregroundStyle(Color.arconteTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func favoritesContent(_ favorites: [FavoriteGame]) -> some View {
        if favorites.isEmpty {
            ContentUnavailableView(
                "Your library is empty",
                systemImage: "heart",
                description: Text(
                    "Explore games and save your favorites to find them here."
                )
            )
            .foregroundStyle(Color.arconteTextSecondary)
        } else {
            favoritesGrid(favorites)
        }
    }
    
    private func favoritesGrid(_ favorites: [FavoriteGame]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(favorites.count) saved games")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.arconteTextSecondary)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(favorites) { favorite in
                        NavigationLink {
                            GameDetailsView(gameID: favorite.gameID)
                        } label: {
                            favoriteCard(favorite)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 120)
        }
    }
    
    private func favoriteCard(_ favorite: FavoriteGame) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            GameCoverImage(coverURL: favorite.coverURL)
                .aspectRatio(3 / 4, contentMode: .fit)
            
            Text(favorite.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.arconteTextPrimary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 4) {
                if let rating = favorite.rating {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.arcontePurple)
                    
                    Text(String(format: "%.1f", rating / 10))
                        .foregroundStyle(Color.arconteTextSecondary)
                } else {
                    Image(systemName: "star")
                        .foregroundStyle(Color.arconteTextSecondary)
                    
                    Text("Not rated")
                        .foregroundStyle(Color.arconteTextSecondary)
                }
            }
            .font(.system(size: 12, weight: .medium))
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .contentShape(Rectangle())
    }
}
