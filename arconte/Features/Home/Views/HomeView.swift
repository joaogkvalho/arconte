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
            VStack(spacing: 0) {
                HomeHeader()
                
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
                            VStack(alignment: .leading, spacing: 24) {
                                if let featuredGame = viewModel.featuredGame ?? viewModel.games.first {
                                    NavigationLink {
                                        GameDetailsView(gameID: featuredGame.id)
                                    } label: {
                                        FeaturedGameCard(game: featuredGame)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal, 20)
                                }
                                
                                gamesList
                            }
                            .padding(.vertical, 12)
                        }
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
    

    private var gamesList: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Popular Games")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Spacer()

                Button("See all") {
                    // Implementaremos posteriormente.
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.arcontePurple)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(viewModel.games) { game in
                        GameHorizontalCard(game: game)
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

#Preview {
    HomeView()
}
