//
//  GenreCard.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 11/11/26.
//

import SwiftUI

struct GenreCard: View {
    let genre: GameGenre

    private var icon: String {
        switch genre.name.lowercased() {
        case "action": "bolt.fill"
        case "adventure": "map.fill"
        case "role-playing (rpg)", "rpg": "person.fill"
        case "shooter": "scope"
        case "strategy": "gamecontroller.fill"
        case "sport": "sportscourt.fill"
        case "racing": "car.fill"
        case "puzzle": "puzzlepiece.fill"
        case "platform": "gamecontroller.fill"
        case "fighting": "figure.martial.arts"
        case "simulation": "gearshape.fill"
        case "indie": "sparkles"
        default: "gamecontroller.fill"
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 40, height: 40)
                .background(Color.arcontePurple.opacity(0.12))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                )

            Text(genre.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.arconteTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 105)
                .minimumScaleFactor(0.85)
        }
        .frame(width: 125, height: 110)
        .background(Color.arconteElevated)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .strokeBorder(.white.opacity(0.06), lineWidth: 1)
        }
    }
}
