//
//  HomeHeader.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import SwiftUI

struct HomeHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            Text("ARCONTE")
                .font(.system(size: 20, weight: .black, design: .none))
                .tracking(0.5)
                .foregroundStyle(Color.arconteTextPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    ZStack {
        Color.arconteBackground
            .ignoresSafeArea()
        
        HomeHeader()
    }
}
