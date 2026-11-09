//
//  ContentView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

@MainActor
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.games.isEmpty {
                    ProgressView("Loading games...")
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if viewModel.games.isEmpty {
                    ContentUnavailableView(
                        "No games found",
                        systemImage: "gamecontroller",
                        description: Text("There are no games available right now.")
                    )
                } else {
                    gamesList
                }
            }
            .navigationTitle("Arconte")
        }
        .task {
            await viewModel.loadPopularGames()
        }
    }
    
    private var gamesList: some View {
        List(viewModel.games) { game in
            HStack(alignment: .center, spacing: 12) {
                GameCoverImage(cover: game.cover)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(game.name)
                        .font(.headline)
                    
                    if let rating = game.rating {
                        HStack(alignment: .center, spacing: 3) {
                            Image(systemName: "star.fill")

                            Text(String(format: "%.1f", rating))
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    if let genres = game.genres, !genres.isEmpty {
                        Text(genres.map(\.name).joined(separator: " • "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 4)
            }
        }
        .refreshable {
            await viewModel.loadPopularGames()
        }
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task {
                    await viewModel.loadPopularGames()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    HomeView()
}
