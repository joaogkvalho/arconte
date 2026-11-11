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
            VStack(alignment: .leading, spacing: 10) {
                GameCoverImage(cover: game.cover)
                    .frame(width: 145, height: 195)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )

                Text(game.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.arconteTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )

                if let rating = game.rating {
                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.arcontePurple)

                        Text(String(format: "%.1f", rating / 10))
                            .foregroundStyle(Color.arconteTextSecondary)
                    }
                    .font(.system(size: 12, weight: .medium))
                }
            }
            .frame(width: 145, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

