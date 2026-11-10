//
//  FavoriteGame.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteGame {
    @Attribute(.unique)
    var gameID: Int
    
    var name: String
    var coverURL: String?
    var rating: Double?
    var addedAt: Date
    
    init(
        gameID: Int,
        name: String,
        coverURL: String?,
        rating: Double?,
    ) {
        self.gameID = gameID
        self.name = name
        self.coverURL = coverURL
        self.rating = rating
        self.addedAt = .now
    }
}
