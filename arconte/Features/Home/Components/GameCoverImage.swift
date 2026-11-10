//
//  GameCoverImage.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct GameCoverImage: View {
    let coverURL: String?
    
    private let cornerRadius: CGFloat = 12
    
    init(cover: GameCover?) {
        self.coverURL = cover?.url
    }
    
    init(coverURL: String?) {
        self.coverURL = coverURL
    }
    
    private var imageURL: URL? {
        guard let rawURL = coverURL else { return nil }
        
        let normalizedURL = rawURL.hasPrefix("//")
            ? "https:\(rawURL)"
            : rawURL
        
        return URL(string: normalizedURL)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.arconteElevated
                
                if let imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.arcontePurple)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                                .clipped()

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
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
            )
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "gamecontroller.fill")
            .font(.system(size: 24))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
