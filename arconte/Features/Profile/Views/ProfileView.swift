//
//  ProfileView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI
import SwiftData

@MainActor
struct ProfileView: View {
    @AppStorage("profileNickname")
    private var nickname = "Player One"
    
    @AppStorage("profileAvatar")
    private var selectedAvatar = "gamecontroller.fill"
    
    @State private var showingEditProfile = false
    @State private var showingAbout = false
    
    @Query(sort: \FavoriteGame.addedAt, order: .reverse)
    private var favorites: [FavoriteGame]
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var averageRating: Double? {
        let ratings = favorites.compactMap(\.rating)

        guard !ratings.isEmpty else {
            return nil
        }

        return ratings.reduce(0, +) / Double(ratings.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    profileHeader
                    activitySection
                    recentlySavedSection
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .background(Color.arconteBackground)
            .toolbar(.hidden, for: .navigationBar)
            .scrollIndicators(.hidden)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditProfile) {
            ProfileEditView(
                nickname: $nickname,
                selectedAvatar: $selectedAvatar
            )
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.arcontePurple.opacity(0.15))
                    .frame(width: 104, height: 104)
                
                Circle()
                    .strokeBorder(
                        Color.arcontePurple.opacity(0.4),
                        lineWidth: 1
                    )
                    .frame(width: 104, height: 104)
                
                Image(systemName: selectedAvatar)
                    .font(.system(size: 38))
                    .foregroundStyle(Color.arcontePurple)
            }
            
            VStack(spacing: 6) {
                Text(nickname)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)
                
                Text("Your personal gaming space.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.arconteTextSecondary)
            }
            
            Button {
                showingEditProfile = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.arcontePurple)
                .padding(.horizontal, 18)
                .padding(.vertical, 11)
                .background(Color.arcontePurple.opacity(0.12))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Your Activity")

            HStack(spacing: 12) {
                statisticCard(
                    title: "Saved Games",
                    value: "\(favorites.count)",
                    icon: "heart.fill"
                )

                statisticCard(
                    title: "Average Rating",
                    value: averageRating.map {
                        String(format: "%.1f", $0 / 10)
                    } ?? "—",
                    icon: "star.fill"
                )
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("About")
            
            VStack(spacing: 0) {
                aboutRow(
                    icon: "info.circle",
                    title: "App Version",
                    value: appVersion
                )
                
                Divider()
                    .overlay(Color.white.opacity(0.06))
                    .padding(.leading, 48)
                
                Button {
                    showingAbout = true
                } label: {
                    HStack(spacing: 8) {
                        aboutRow(
                            icon: "gamecontroller",
                            title: "Arconte",
                            value: "Game Discovery"
                        )

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.arconteTextSecondary.opacity(0.6))
                    }
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showingAbout) {
                    AboutArconteView()
                }
            }
            .padding(.horizontal, 16)
            .background(Color.arconteElevated)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
    
    @ViewBuilder
    private var recentlySavedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Recently Saved")

            if favorites.isEmpty {
                recentlySavedEmptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        ForEach(Array(favorites.prefix(3))) { favorite in
                            NavigationLink {
                                GameDetailsView(gameID: favorite.gameID)
                            } label: {
                                recentGameCard(favorite)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color.arconteTextPrimary)
    }
    
    private func aboutRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 32)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.arconteTextPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13))
                .foregroundStyle(Color.arconteTextSecondary)
        }
        .padding(.vertical, 17)
    }
    
    private func statisticCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 42, height: 42)
                .background(Color.arcontePurple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading, spacing: 5) {
                Text(value)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.arconteTextSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.arconteElevated)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private func recentGameCard(_ favorite: FavoriteGame) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            GameCoverImage(coverURL: favorite.coverURL)
                .frame(width: 120, height: 155)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            Text(favorite.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.arconteTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 120, alignment: .leading)
        }
        .contentShape(Rectangle())
    }
    
    private var recentlySavedEmptyState: some View {
        HStack(spacing: 14) {
            Image(systemName: "heart")
                .font(.system(size: 23))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 52, height: 52)
                .background(Color.arcontePurple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 5) {
                Text("No games saved yet")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Text("Your recently saved games will appear here.")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.arconteTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.arconteElevated)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
