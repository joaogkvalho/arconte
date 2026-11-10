//
//  GameHorizontalCard.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct GameHorizontalCard: View {
    let game: Game

    var body: some View {
        NavigationLink {
            GameDetailsView(gameID: game.id)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                GameCoverImage(cover: game.cover)
                    .frame(width: 140, height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(game.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.arconteTextPrimary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let rating = game.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.arcontePurple)

                        Text(String(format: "%.1f", rating))
                            .foregroundStyle(Color.arconteTextSecondary)
                    }
                    .font(.system(size: 12, weight: .medium))
                }
            }
            .frame(width: 140, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
