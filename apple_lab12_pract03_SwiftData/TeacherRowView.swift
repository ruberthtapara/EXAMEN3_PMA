//
//  TeacherRowView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import SwiftUI

struct TeacherRowView: View {
    let teacher: Teacher

    // Gradiente dinámico según estado
    private var avatarGradient: LinearGradient {
        if teacher.isActive {
            return LinearGradient(
                colors: [Color.indigo, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color(uiColor: .systemGray3), Color(uiColor: .systemGray4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Avatar moderno con gradiente Índigo/Púrpura
            ZStack {
                Circle()
                    .fill(avatarGradient)
                    .frame(width: 50, height: 50)
                    .shadow(color: (teacher.isActive ? Color.indigo : Color.gray).opacity(0.3), radius: 5, x: 0, y: 3)

                Text(teacher.initials)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            // Datos del docente
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(teacher.fullName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    // Badge de estado moderno
                    if teacher.isActive {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(Color.emeraldGreen)
                                .frame(width: 6, height: 6)
                            Text("Activo")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color.emeraldGreen)
                        }
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.emeraldGreen.opacity(0.12))
                        .clipShape(Capsule())
                    } else {
                        Text("Inactivo")
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.secondary.opacity(0.12))
                            .foregroundColor(.secondary)
                            .clipShape(Capsule())
                    }
                }

                if !teacher.subject.isEmpty {
                    Text(teacher.subject)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.indigo)
                }

                if !teacher.email.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 11))
                        Text(teacher.email)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color.indigo.opacity(0.4))
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

// Extensión para verde esmeralda elegante
private extension Color {
    static let emeraldGreen = Color(red: 0.10, green: 0.68, blue: 0.38)
}
