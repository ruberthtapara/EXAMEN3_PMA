//
//  ContentView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Teacher.lastName), SortDescriptor(\Teacher.firstName)])
    private var teachers: [Teacher]

    @State private var searchText: String = ""
    @State private var showingAddSheet: Bool = false
    @State private var teacherToEdit: Teacher? = nil

    private var filteredTeachers: [Teacher] {
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if query.isEmpty {
            return teachers
        }
        return teachers.filter { teacher in
            teacher.firstName.lowercased().contains(query) ||
            teacher.lastName.lowercased().contains(query) ||
            teacher.subject.lowercased().contains(query) ||
            teacher.email.lowercased().contains(query) ||
            teacher.phone.contains(query)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Barra de búsqueda moderna con acento Índigo
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.indigo)
                        .font(.system(size: 15, weight: .semibold))

                    TextField("Search teachers...", text: $searchText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.indigo.opacity(searchText.isEmpty ? 0.15 : 0.5), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 8)

                // Lista de Docentes o Estado Vacío
                if filteredTeachers.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredTeachers) { teacher in
                            TeacherRowView(teacher: teacher)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    teacherToEdit = teacher
                                }
                        }
                        .onDelete(perform: deleteTeachers)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Teachers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.indigo, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTeacherView()
            }
            .sheet(item: $teacherToEdit) { teacher in
                EditTeacherView(teacher: teacher)
            }
            .onAppear {
                seedInitialDataIfNeeded()
            }
        }
        .tint(.indigo)
    }

    // Vista cuando no hay resultados o la lista está vacía
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 90, height: 90)

                Image(systemName: searchText.isEmpty ? "graduationcap.fill" : "magnifyingglass")
                    .font(.system(size: 40))
                    .foregroundColor(.indigo)
            }

            Text(searchText.isEmpty ? "No teachers found" : "No results for \"\(searchText)\"")
                .font(.headline)
                .foregroundColor(.primary)

            Text(searchText.isEmpty ? "Add your first teacher to get started" : "Try searching by name, subject or email")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if searchText.isEmpty {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Teacher", systemImage: "plus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.indigo, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: Color.indigo.opacity(0.35), radius: 6, x: 0, y: 3)
                }
                .padding(.top, 8)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func deleteTeachers(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let teacher = filteredTeachers[index]
                modelContext.delete(teacher)
            }
        }
    }

    // Datos de muestra iniciales (de las capturas del laboratorio)
    private func seedInitialDataIfNeeded() {
        if teachers.isEmpty {
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"

            let t1 = Teacher(
                firstName: "Jaime",
                lastName: "Gomez",
                email: "jgomezm@tecsup.edu.pe",
                phone: "945784125",
                dateOfBirth: df.date(from: "2022/08/01") ?? Date(),
                subject: "Java Senior",
                hireDate: df.date(from: "2025/06/01") ?? Date(),
                isActive: true
            )

            let t2 = Teacher(
                firstName: "Juan",
                lastName: "Leon",
                email: "jleon@tecsup.edu.pe",
                phone: "987654321",
                dateOfBirth: df.date(from: "1990/04/15") ?? Date(),
                subject: "IOS Developer",
                hireDate: df.date(from: "2024/02/01") ?? Date(),
                isActive: true
            )

            modelContext.insert(t1)
            modelContext.insert(t2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Teacher.self, inMemory: true)
}
