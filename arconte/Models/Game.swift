//
//  Game.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import Foundation

struct Game: Decodable, Identifiable {
    let id: Int
    let name: String
    let summary: String?
    let rating: Double?
    let firstReleaseDate: Int?
    let genres: [GameGenre]?
    let platforms: [GamePlatform]?
    let cover: GameCover?
    let screenshots: [GameScreenshot]?
}

struct GameGenre: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct GamePlatform: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct GameCover: Decodable {
    let id: Int
    let url: String
}

struct GameScreenshot: Decodable, Identifiable {
    let id: Int
    let url: String
}
