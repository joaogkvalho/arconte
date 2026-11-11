//
//  RecentlyViewedGame.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 11/11/26.
//

import Foundation
import SwiftData

@Model
final class RecentlyViewedGame {
    @Attribute(.unique)
    var gameID: Int

    var name: String
    var coverURL: String?
    var rating: Double?
    var viewedAt: Date

    init(
        gameID: Int,
        name: String,
        coverURL: String?,
        rating: Double?
    ) {
        self.gameID = gameID
        self.name = name
        self.coverURL = coverURL
        self.rating = rating
        self.viewedAt = .now
    }
}
