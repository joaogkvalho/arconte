//
//  MainTabView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI
import UIKit

private enum AppTab: Hashable {
    case home
    case search
    case favorites
    case profile
    
    var accessibilityName: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var isKeyboardVisible = false
    
    @Namespace private var tabAnimation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .search:
                    SearchView()
                case .favorites:
                    placeholderView(
                        title: "Favorites",
                        description: "Your saved games will appear here.",
                        icon: "heart"
                    )
                case .profile:
                    placeholderView(
                        title: "Profile",
                        description: "Your profile and preferences.",
                        icon: "person.crop.circle"
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if !isKeyboardVisible {
                bottomNavigation
                    .padding(.bottom, 8)
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
            }
        }
        .background(
            Color.arconteBackground
                .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillShowNotification
            )
        ) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                isKeyboardVisible = true
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification
            )
        ) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                isKeyboardVisible = false
            }
        }
    }
    
    private var bottomNavigation: some View {
        HStack(spacing: 16) {
            tabButton(
                icon: "house.fill",
                tab: .home
            )

            tabButton(
                icon: "magnifyingglass",
                tab: .search
            )

            tabButton(
                icon: "heart",
                tab: .favorites
            )

            tabButton(
                icon: "person.crop.circle",
                tab: .profile
            )
        }
        .padding(8)
        .background(Color.arconteElevated)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .strokeBorder(
                    Color.white.opacity(0.06),
                    lineWidth: 1
                )
        }
        .shadow(
            color: .black.opacity(0.25),
            radius: 16,
            x: 0,
            y: 6
        )
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    private func tabButton(icon: String, tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        
        return Button {
            withAnimation(.spring(
                response: 0.35,
                dampingFraction: 0.75,
                blendDuration: 0.2
            )) {
                selectedTab = tab
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color.arcontePurple.opacity(0.20))
                        .matchedGeometryEffect(
                            id: "selectedTab",
                            in: tabAnimation
                        )
                        .frame(width: 58, height: 54)
                }
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        isSelected
                            ? Color.arcontePurple
                            : Color.arconteTextSecondary
                    )
            }
            .frame(width: 54, height: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.accessibilityName)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private func placeholderView(
        title: String,
        description: String,
        icon: String
    ) -> some View {
        NavigationStack {
            ContentUnavailableView(
                title,
                systemImage: icon,
                description: Text(description)
            )
            .background(Color.arconteBackground)
            .toolbar(.hidden)
        }
    }
}
