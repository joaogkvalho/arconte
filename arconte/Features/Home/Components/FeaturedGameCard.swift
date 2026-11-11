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
            ZStack {
                backgroundImage
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0.15), location: 0),
                        .init(color: .clear, location: 0.3),
                        .init(color: .black.opacity(0.45), location: 0.55),
                        .init(color: .black.opacity(0.9), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("FEATURED GAME")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(2)
                            .foregroundStyle(Color.arcontePurple)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 7)
                            .background {
                                Capsule()
                                    .fill(Color.black.opacity(0.75))
                            }
                            .overlay {
                                Capsule()
                                    .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                            }

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(.black.opacity(0.35))
                            .clipShape(Circle())
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.name)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        HStack(spacing: 14) {
                            if let rating = game.rating {
                                HStack(spacing: 5) {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(Color.arcontePurple)

                                    Text(String(format: "%.1f", rating / 10))
                                        .foregroundStyle(.white)
                                }
                            }

                            Text(genresText)
                                .foregroundStyle(.white.opacity(0.8))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .font(.system(size: 12, weight: .medium))
                    }
                }
                .padding(20)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(.white.opacity(0.08), lineWidth: 1)
            }
        }
        .frame(height: 250)
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

