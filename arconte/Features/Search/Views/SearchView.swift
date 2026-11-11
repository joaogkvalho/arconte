//
//  SearchView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI
import SwiftData

@MainActor
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    @FocusState private var isSearchFocused: Bool
    
    @Query(
        sort: \RecentlyViewedGame.viewedAt,
        order: .reverse
    )
    private var recentlyViewedGames: [RecentlyViewedGame]
    
    private let columns = [
        GridItem(.flexible(), spacing: 14, alignment: .top),
        GridItem(.flexible(), spacing: 14, alignment: .top),
    ]
    
    private let searchSuggestions = [
        "Elden Ring",
        "Cyberpunk 2077",
        "Minecraft",
        "God of War",
        "The Witcher 3"
    ]
    
    private func recordRecentlyViewed(_ game: Game) {
        let gameID = game.id

        let descriptor = FetchDescriptor<RecentlyViewedGame>(
            predicate: #Predicate { item in
                item.gameID == gameID
            }
        )

        do {
            let existingGame = try modelContext.fetch(descriptor).first

            if let existingGame {
                existingGame.name = game.name
                existingGame.coverURL = game.cover?.url
                existingGame.rating = game.rating
                existingGame.viewedAt = .now
            } else {
                let recentlyViewedGame = RecentlyViewedGame(
                    gameID: game.id,
                    name: game.name,
                    coverURL: game.cover?.url,
                    rating: game.rating
                )

                modelContext.insert(recentlyViewedGame)
            }

            try modelContext.save()
        } catch {
            print("Failed to save recently viewed game: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                header
                
                searchField
                
                searchContent
            }
            .padding(.top, 12)
            .background {
                Color.arconteBackground
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchFocused = false
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar(.hidden, for: .navigationBar)
            .task(id: searchText) {
                let query = searchText.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                
                guard query.count >= 2 else {
                    viewModel.clearSearch()
                    return
                }
                
                do {
                    try await Task.sleep(for: .milliseconds(400))
                } catch {
                    return
                }
                
                await viewModel.searchGames(query: query)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Discover")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)
            
            Text("Find your next adventure.")
                .font(.system(size: 14))
                .foregroundStyle(Color.arconteTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.arcontePurple)
            
            TextField("Search games...", text: $searchText)
                .font(.system(size: 15))
                .foregroundStyle(Color.arconteTextPrimary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isSearchFocused)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.arconteTextSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.arconteElevated)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var searchContent: some View {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emptySearchState
        } else if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
            minimumQueryState
        } else if viewModel.isLoading && viewModel.games.isEmpty {
            ProgressView()
                .tint(.arcontePurple)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("Somethin when wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.searchGames(query: searchText)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.arcontePurple)
            }
        } else if viewModel.hasSearched && viewModel.games.isEmpty {
            ContentUnavailableView(
                "No games found",
                systemImage: "magnifyingglass",
                description: Text("Try again with a different name.")
            )
        } else {
            resultsList
        }
    }
    
    private var resultsList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Search Results")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.games) { game in
                        NavigationLink {
                            GameDetailsView(gameID: game.id)

                        } label: {
                            searchResultCard(game)
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                recordRecentlyViewed(game)
                            }
                        )
                    }

                    if viewModel.paginationErrorMessage != nil {
                        VStack(spacing: 8) {
                            Text("Couldn't load more games")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.arconteTextSecondary)

                            Button("Try again") {
                                Task {
                                    await viewModel.loadMoreGames()
                                }
                            }
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.arcontePurple)
                        }
                        .frame(maxWidth: .infinity)
                        .gridCellColumns(2)
                        .padding(.vertical, 16)
                    }

                    if !viewModel.games.isEmpty {
                        Color.clear
                            .frame(height: 1)
                            .gridCellColumns(2)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreGames()
                                }
                            }
                    }
                }
                
                if viewModel.isLoadingMore {
                    ProgressView()
                        .tint(.arcontePurple)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollDismissesKeyboard(.immediately)
    }

    private func searchResultCard(_ game: Game) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            GameCoverImage(cover: game.cover)
                .aspectRatio(3 / 4, contentMode: .fit)
            
            Text(game.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.arconteTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 4) {
                if let rating = game.rating {
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
    
    private var emptySearchState: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                if !recentlyViewedGames.isEmpty {
                    recentlyExploredSection
                }
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Need some inspiration?")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.arconteTextPrimary)

                    Text("Try searching for one of these games.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.arconteTextSecondary)

                    ForEach(searchSuggestions, id: \.self) { suggestion in
                        Button {
                            searchText = suggestion
                            isSearchFocused = false
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.arcontePurple)

                                Text(suggestion)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.arconteTextPrimary)

                                Spacer()

                                Image(systemName: "arrow.up.left")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.arconteTextSecondary)
                            }
                            .padding(.horizontal, 15)
                            .frame(height: 52)
                            .background(Color.arconteElevated)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 14,
                                    style: .continuous
                                )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var recentlyExploredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recently Explored")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(recentlyViewedGames.prefix(5)) { game in
                        NavigationLink {
                            GameDetailsView(gameID: game.gameID)
                        } label: {
                            RecentlyViewedGameCard(game: game)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var minimumQueryState: some View {
        VStack(spacing: 12) {
            Image(systemName: "text.magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(Color.arcontePurple)

            Text("Keep typing")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)

            Text("Enter at least 2 characters to search for games.")
                .font(.system(size: 13))
                .foregroundStyle(Color.arconteTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
