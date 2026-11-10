//
//  arconteApp.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI
import SwiftData

@main
struct ArconteApp: App {
    var body: some Scene {
        WindowGroup {
           MainTabView()
        }
        .modelContainer(for: FavoriteGame.self)
    }
}
