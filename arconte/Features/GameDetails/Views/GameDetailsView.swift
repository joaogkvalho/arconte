//
//  GameDetailsView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI

@MainActor
struct GameDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = GameDetailsViewModel()
    
    let gameID: Int
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.game == nil {
                ProgressView("Loading game details...")
                    .tint(.arcontePurple)
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if let game = viewModel.game {
                detailsContent(for: game)
            } else {
                ProgressView()
                    .tint(.arcontePurple)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.arconteBackground)
        .toolbar(.hidden, for: .navigationBar)
        .task(id: gameID) {
            await viewModel.loadGameDetails(id: gameID)
        }
    }
    
    private func detailsContent(for game: Game) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                heroSection(for: game)
                
                gameInformation(for: game)
                
                aboutSection(for: game)
                
                screenshotsSections(for: game)
            }
            .padding(.bottom, 120)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func heroSection(for game: Game) -> some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                heroImage(for: game)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
            }
            
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.15), location: 0),
                    .init(color: .clear, location: 0.35),
                    .init(color: .black.opacity(0.65), location: 0.7),
                    .init(color: .black.opacity(0.95), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    .padding(.top, 36)
                    
                    Spacer()
                    
                    FavoriteButton(game: game)
                        .padding(.top, 36)
                }
                
                Spacer()
                
                Text(game.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                
                if let genres = game.genres, !genres.isEmpty {
                    Text(genres.map(\.name).joined(separator: " • "))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(1)
                }
            }
            .padding()
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    private func heroImage(for game: Game) -> some View {
        let rawURL = game.screenshots?.first?.url ?? game.cover?.url

        if let rawURL, let url = imageURL(from: rawURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    heroLoadingPlaceholder

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    heroPlaceholder

                @unknown default:
                    heroPlaceholder
                }
            }
        } else {
            heroPlaceholder
        }
    }

    private var heroLoadingPlaceholder: some View {
        Rectangle()
            .fill(Color.arconteElevated)
            .overlay {
                ProgressView()
                    .tint(.arcontePurple)
            }
    }

    private var heroPlaceholder: some View {
        Rectangle()
            .fill(Color.arconteElevated)
            .overlay {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
    }
    
    private func gameInformation(for game: Game) -> some View {
        HStack(spacing: 20) {
            if let rating = game.rating {
                informationItem(
                    icon: "star.fill",
                    value: String(format: "%.1f", rating / 10),
                    label: "Rating"
                )
            }
            
            if let releaseDate = game.firstReleaseDate {
                informationItem(
                    icon: "calendar",
                    value: releaseDate.formattedDate,
                    label: "Release"
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func informationItem(icon: String, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(Color.arcontePurple)
                
                Text(label)
                    .foregroundStyle(Color.arconteTextSecondary)
            }
            .font(.system(size: 12, weight: .medium))
            
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)
        }
    }
    
    private func aboutSection(for game: Game) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About this game")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)
            
            Text(game.summary ?? "No description available for this game.")
                .font(.system(size: 14))
                .foregroundStyle(Color.arconteTextSecondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func screenshotsSections(for game: Game) -> some View {
        if let screenshots = game.screenshots, !screenshots.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text("Screenshots")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(screenshots) { screenshot in
                            screenshotCard(for: screenshot)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }

    private func screenshotCard(for screenshot: GameScreenshot) -> some View {
        Group {
            if let url = imageURL(from: screenshot.url) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        screenshotLoadingPlaceholder

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        screenshotPlaceholder

                    @unknown default:
                        screenshotPlaceholder
                    }
                }
            } else {
                screenshotPlaceholder
            }
        }
        .frame(width: 250, height: 145)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var screenshotLoadingPlaceholder: some View {
        Rectangle()
            .fill(Color.arconteElevated)
            .overlay {
                ProgressView()
                    .tint(.arcontePurple)
            }
    }

    private var screenshotPlaceholder: some View {
        Rectangle()
            .fill(Color.arconteElevated)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
    }

    private func imageURL(from rawURL: String) -> URL? {
        let normalizedURL = rawURL.hasPrefix("//")
            ? "https:\(rawURL)"
            : rawURL
        
        return URL(string: normalizedURL)
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label(
                "Unable to load game",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task {
                    await viewModel.loadGameDetails(id: gameID)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.arcontePurple)
        }
    }
}

private extension Int {
    var formattedDate: String {
        Date(timeIntervalSince1970: TimeInterval(self))
            .formatted(.dateTime.month(.abbreviated).year())
    }
}
