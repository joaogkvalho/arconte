//
//  RecentlyViewedGameCard.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 11/11/26.
//

import SwiftUI

struct RecentlyViewedGameCard: View {
    let game: RecentlyViewedGame

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GameCoverImage(coverURL: game.coverURL)
                .frame(width: 100, height: 135)

            Text(game.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.arconteTextPrimary)
                .lineLimit(1)
                .frame(width: 100, alignment: .leading)
        }
    }
}
