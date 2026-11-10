//
//  FeaturedGameCard.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct FeaturedGameCard: View {
    let game: Game

    private var imageURL: URL? {
        let rawURL = game.screenshots?.first?.url ?? game.cover?.url

        guard let rawURL else {
            return nil
        }

        let normalizedURL = rawURL.hasPrefix("//")
            ? "https:\(rawURL)"
            : rawURL

        return URL(string: normalizedURL)
    }

    private var genresText: String {
        guard let genres = game.genres, !genres.isEmpty else {
            return "Discover this game"
        }

        return genres.map(\.name).joined(separator: " • ")
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                backgroundImage
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.15),
                        .init(color: .black.opacity(0.25), location: 0.45),
                        .init(color: .black.opacity(0.65), location: 0.75),
                        .init(color: .black.opacity(0.92), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 12) {
                    Text("FEATURED GAME")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(2.2)
                        .foregroundStyle(Color.arcontePurple)

                    Text(game.name)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        if let rating = game.rating {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")

                                Text(String(format: "%.0f", rating))
                            }
                            .foregroundStyle(Color.arcontePurple)
                        }

                        Text(genresText)
                            .foregroundStyle(.white.opacity(0.8))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .font(.system(size: 12, weight: .medium))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .frame(height: 230)
        .frame(maxWidth: .infinity)
    }


    @ViewBuilder
    private var backgroundImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                case .empty, .failure:
                    placeholder

                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.arconteElevated)
            .overlay {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
    }
}

#Preview {
    FeaturedGameCard(
        game: Game(
            id: 1,
            name: "Example Game",
            summary: nil,
            rating: 92.5,
            firstReleaseDate: nil,
            genres: [
                GameGenre(id: 1, name: "Adventure"),
                GameGenre(id: 2, name: "RPG")
            ],
            platforms: nil,
            cover: nil,
            screenshots: nil
        )
    )
    .padding()
}
