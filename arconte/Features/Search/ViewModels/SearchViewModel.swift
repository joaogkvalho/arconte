//
//  SearchViewModel.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class SearchViewModel {
    private let gameService: GameService
    private let pageSize = 20

    private(set) var games: [Game] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var hasSearched = false
    private(set) var hasMoreResults = false
    private(set) var errorMessage: String?
    private(set) var paginationErrorMessage: String?

    private var currentQuery = ""
    private var nextOffset = 0
    private var searchGeneration = UUID()

    init(gameService: GameService? = nil) {
        self.gameService = gameService ?? GameService()
    }

    func searchGames(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        let generation = UUID()
        searchGeneration = generation

        guard trimmedQuery.count >= 2 else {
            clearSearch()
            return
        }

        currentQuery = trimmedQuery
        nextOffset = 0

        games = []
        hasMoreResults = false
        isLoadingMore = false
        paginationErrorMessage = nil

        isLoading = true
        hasSearched = true
        errorMessage = nil

        defer {
            if searchGeneration == generation {
                isLoading = false
            }
        }

        do {
            let results = try await gameService.searchGames(
                query: trimmedQuery,
                offset: 0
            )

            try Task.checkCancellation()

            guard searchGeneration == generation else { return }

            games = results
            nextOffset = results.count
            hasMoreResults = results.count == pageSize

        } catch is CancellationError {
            return

        } catch {
            guard searchGeneration == generation else { return }
            errorMessage = error.localizedDescription
        }
    }

    func loadMoreGames() async {
        guard !currentQuery.isEmpty,
              hasMoreResults,
              !isLoading,
              !isLoadingMore else {
            return
        }

        let generation = searchGeneration
        let query = currentQuery
        let offset = nextOffset

        isLoadingMore = true
        paginationErrorMessage = nil

        defer {
            if searchGeneration == generation {
                isLoadingMore = false
            }
        }

        do {
            let results = try await gameService.searchGames(
                query: query,
                offset: offset
            )

            try Task.checkCancellation()

            guard searchGeneration == generation,
                  currentQuery == query else {
                return
            }

            let existingIDs = Set(games.map(\.id))
            let newGames = results.filter {
                !existingIDs.contains($0.id)
            }

            games.append(contentsOf: newGames)

            nextOffset += results.count
            hasMoreResults = results.count == pageSize

        } catch is CancellationError {
            return

        } catch {
            guard searchGeneration == generation else { return }
            paginationErrorMessage = error.localizedDescription
        }
    }

    func clearSearch() {
        searchGeneration = UUID()

        currentQuery = ""
        nextOffset = 0

        games = []
        hasMoreResults = false
        hasSearched = false

        errorMessage = nil
        paginationErrorMessage = nil

        isLoading = false
        isLoadingMore = false
    }
}
