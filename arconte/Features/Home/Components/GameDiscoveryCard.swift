//
//  GameDiscoveryCard.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 11/11/26.
//

import SwiftUI

struct GameDiscoveryCard: View {
    let game: Game
    
    private var genresText: String {
        guard let genres = game.genres, !genres.isEmpty else {
            return "Unknown genre"
        }
        
        return genres
            .prefix(2)
            .map(\.name)
            .joined(separator: " • ")
    }
    
    var body: some View {
        NavigationLink {
            GameDetailsView(gameID: game.id)
        } label: {
            HStack(spacing: 14) {
                GameCoverImage(cover: game.cover)
                    .frame(width: 100, height: 125)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(game.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.arconteTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(genresText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.arconteTextSecondary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    if let rating = game.rating {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.arcontePurple)
                            
                            Text(String(format: "%.1f", rating / 10))
                                .foregroundStyle(Color.arconteTextSecondary)
                        }
                        .font(.system(size: 12, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 5)
            }
            .padding(10)
            .frame(width: 300, height: 145)
            .background(Color.arconteElevated)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .strokeBorder(.white.opacity(0.06), lineWidth: 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
