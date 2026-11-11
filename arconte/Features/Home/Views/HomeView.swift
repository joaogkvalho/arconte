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
    
    private var gamesForSections: [Game] {
        viewModel.games.filter {
            $0.id != (viewModel.featuredGame ?? viewModel.games.first)?.id
        }
    }
    
    private var popularGames: [Game] {
        Array(gamesForSections.prefix(6))
    }
    
    private var moreToExploreGames: [Game] {
        Array(gamesForSections.dropFirst(6))
    }
    
    private var availableGenres: [GameGenre] {
        var uniqueGenres: [Int: GameGenre] = [:]

        for game in viewModel.games {
            for genre in game.genres ?? [] {
                uniqueGenres[genre.id] = genre
            }
        }

        return uniqueGenres.values.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    if viewModel.isLoading && viewModel.games.isEmpty {
                        ProgressView("Loading games...")
                            .tint(.arcontePurple)
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else if viewModel.games.isEmpty {
                        ContentUnavailableView(
                            "No games found",
                            systemImage: "gamecontroller",
                            description: Text("There are no games available right now.")
                        )
                    } else {
                        ScrollView {
                            HomeHeader()
                            
                            VStack(alignment: .leading, spacing: 30) {
                                if let featuredGame = viewModel.featuredGame ?? viewModel.games.first {
                                    NavigationLink {
                                        GameDetailsView(gameID: featuredGame.id)
                                    } label: {
                                        FeaturedGameCard(game: featuredGame)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal, 20)
                                }

                                popularGamesSection

                                if !moreToExploreGames.isEmpty {
                                    moreToExploreSection
                                }
                                
                                if !availableGenres.isEmpty {
                                    browseByGenreSection
                                }
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 120)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.arconteBackground)
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .task {
            await viewModel.loadPopularGames()
        }
    }

    private var popularGamesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Popular Games")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Spacer()
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(popularGames) { game in
                        GameHorizontalCard(game: game)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var moreToExploreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("More to Explore")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Text("More games worth checking out.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(moreToExploreGames) { game in
                        GameDiscoveryCard(game: game)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var browseByGenreSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Browse by Genre")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Text("Explore games by your favorite categories.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(availableGenres) { genre in
                        GenreCard(genre: genre)
                    }
                }
                .padding(.horizontal, 20)
            }
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
