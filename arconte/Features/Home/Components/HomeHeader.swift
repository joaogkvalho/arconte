//
//  HomeHeader.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct HomeHeader: View {
    @AppStorage("profileNickname")
    private var nickname = "Player One"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("ARCONTE")
                    .font(.system(size: 22, weight: .black))
                    .tracking(1)
                    .foregroundStyle(Color.arconteTextPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome back, \(nickname)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)
                
                Text("Ready for your next adventure?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
}
