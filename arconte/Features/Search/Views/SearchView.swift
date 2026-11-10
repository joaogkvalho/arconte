//
//  SearchView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI

@MainActor
struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    @FocusState private var isSearchFocused: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 14, alignment: .top),
        GridItem(.flexible(), spacing: 14, alignment: .top),
    ]
    
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
                
                guard !query.isEmpty else {
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
            ContentUnavailableView(
                "Find your next game",
                systemImage: "gamecontroller",
                description: Text("Search for your favorite games.")
            )
            .foregroundStyle(Color.arconteTextSecondary)
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
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollDismissesKeyboard(.interactively)
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
}
