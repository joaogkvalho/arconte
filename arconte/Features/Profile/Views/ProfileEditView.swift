//
//  ProfileEditView.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 10/11/26.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var nickname: String
    @Binding var selectedAvatar: String

    @State private var draftNickname: String
    @State private var draftAvatar: String
    
    private let avatars = [
        "gamecontroller.fill",
        "person.fill",
        "flame.fill",
        "bolt.fill",
        "crown.fill",
        "snowflake",
        "star.fill",
        "moon.stars.fill"
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    init(
        nickname: Binding<String>,
        selectedAvatar: Binding<String>
    ) {
        self._nickname = nickname
        self._selectedAvatar = selectedAvatar

        self._draftNickname = State(
            initialValue: nickname.wrappedValue
        )

        self._draftAvatar = State(
            initialValue: selectedAvatar.wrappedValue
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    nicknameSection
                    avatarSection
                }
                .padding(20)
            }
            .background(Color.arconteBackground)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.arconteTextSecondary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmedNickname = draftNickname.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        
                        nickname = trimmedNickname.isEmpty
                            ? "Player One"
                            : trimmedNickname
                        
                        selectedAvatar = draftAvatar

                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.arcontePurple)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nickname")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)

            TextField("Enter your nickname", text: $draftNickname)
                .font(.system(size: 15))
                .padding(16)
                .background(Color.arconteElevated)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
        }
    }
    
    private var avatarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose your avatar")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.arconteTextPrimary)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(avatars, id: \.self) { avatar in
                    avatarButton(avatar)
                }
            }
        }
    }
    
    private func avatarButton(_ avatar: String) -> some View {
        let isSelected = draftAvatar == avatar
        
        return Button {
            draftAvatar = avatar
        } label: {
            Image(systemName: avatar)
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(
                    isSelected
                        ? Color.arcontePurple
                        : Color.arconteTextSecondary
                )
                .frame(maxWidth: .infinity)
                .frame(height: 76)
                .background(
                    isSelected
                        ? Color.arcontePurple.opacity(0.15)
                        : Color.arconteElevated
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isSelected
                                ? Color.arcontePurple
                                : Color.clear,
                            lineWidth: 1.5
                        )
                }
        }
        .buttonStyle(.plain)
    }
}
