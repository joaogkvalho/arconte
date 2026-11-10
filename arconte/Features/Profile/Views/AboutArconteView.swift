//
//  AboutArconteView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI

struct AboutArconteView: View {
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    appHeader
                    descriptionSection
                    technologiesSection
                    dataSection
                }
                .padding(20)
            }
            .background(Color.arconteBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.arcontePurple)
                }
            }
            .toolbarBackground(Color.arconteBackground, for: .navigationBar)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }

    private var appHeader: some View {
        VStack(spacing: 14) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 42))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 100, height: 100)
                .background(Color.arcontePurple.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 28))

            VStack(spacing: 6) {
                Text("Arconte")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.arconteTextPrimary)

                Text("Discover your next adventure.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.arconteTextSecondary)
            }

            Text("Version \(appVersion)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.arcontePurple)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Color.arcontePurple.opacity(0.12))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("About the app")

            Text(
                "Arconte is a game discovery experience designed to help players explore games, discover new adventures and build their personal library."
            )
            .font(.system(size: 14))
            .foregroundStyle(Color.arconteTextSecondary)
            .lineSpacing(5)
        }
    }

    private var technologiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Built with")

            VStack(spacing: 0) {
                technologyRow("SwiftUI", icon: "swift")
                technologyDivider
                technologyRow("Swift Concurrency", icon: "arrow.trianglehead.2.clockwise")
                technologyDivider
                technologyRow("SwiftData", icon: "externaldrive")
                technologyDivider
                technologyRow("REST API", icon: "network")
            }
            .padding(.horizontal, 16)
            .background(Color.arconteElevated)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Game data")

            HStack(spacing: 14) {
                Image(systemName: "gamecontroller")
                    .font(.system(size: 21))
                    .foregroundStyle(Color.arcontePurple)

                VStack(alignment: .leading, spacing: 4) {
                    Text("IGDB")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.arconteTextPrimary)

                    Text("Game information and artwork.")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.arconteTextSecondary)
                }

                Spacer()
            }
            .padding(16)
            .background(Color.arconteElevated)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color.arconteTextPrimary)
    }

    private func technologyRow(_ title: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundStyle(Color.arcontePurple)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.arconteTextPrimary)

            Spacer()
        }
        .padding(.vertical, 15)
    }

    private var technologyDivider: some View {
        Divider()
            .overlay(Color.white.opacity(0.06))
            .padding(.leading, 42)
    }
}
