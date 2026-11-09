//
//  GameCoverImage.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct GameCoverImage: View {
    let cover: GameCover?
    
    private var imageURL: URL? {
        guard let rawURL = cover?.url else {
            return nil
        }
        
        let normalizedURL = rawURL.hasPrefix("//")
            ? "https:\(rawURL)"
            : rawURL
        
        return URL(string: normalizedURL)
    }
    
    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure:
                        placeholder
                        
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 80, height: 80)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var placeholder: some View {
        Image(systemName: "gamecontroller.fill")
            .font(.system(size: 24))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GameCoverImage(cover: nil)
}
