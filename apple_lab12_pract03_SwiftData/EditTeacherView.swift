//
//  EditTeacherView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import SwiftUI
import SwiftData

struct EditTeacherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var teacher: Teacher

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dateOfBirth: Date = Date()

    @State private var subject: String = ""
    @State private var hireDate: Date = Date()
    @State private var isActive: Bool = true

    @State private var showDeleteConfirmation: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                // SECCIÓN 1: INFORMACIÓN PERSONAL
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 20)
                        TextField("First Name", text: $firstName)
                            .textInputAutocapitalization(.words)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "person.text.rectangle.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 20)
                        TextField("Last Name", text: $lastName)
                            .textInputAutocapitalization(.words)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 20)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 20)
                        TextField("Phone", text: $phone)
                            .keyboardType(.phonePad)
                    }

                    DatePicker(
                        selection: $dateOfBirth,
                        displayedComponents: .date
                    ) {
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundColor(.indigo)
                                .frame(width: 20)
                            Text("Date of Birth")
                        }
                    }
                } header: {
                    Label("PERSONAL INFORMATION", systemImage: "person.crop.circle")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                }

                // SECCIÓN 2: INFORMACIÓN PROFESIONAL
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.purple)
                            .frame(width: 20)
                        TextField("Subject / Specialty", text: $subject)
                            .textInputAutocapitalization(.words)
                    }

                    DatePicker(
                        selection: $hireDate,
                        displayedComponents: .date
                    ) {
                        HStack(spacing: 12) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.purple)
                                .frame(width: 20)
                            Text("Hire Date")
                        }
                    }

                    Toggle(isOn: $isActive) {
                        HStack(spacing: 12) {
                            Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isActive ? .green : .secondary)
                                .frame(width: 20)
                            Text("Active")
                        }
                    }
                    .tint(.green)
                } header: {
                    Label("PROFESSIONAL INFORMATION", systemImage: "sparkles")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }

                // SECCIÓN 3: BORRADO
                Section {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "trash.fill")
                            Text("Delete Teacher")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Edit Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.bold)
                    .disabled(!isValid)
                }
            }
            .tint(.indigo)
            .confirmationDialog(
                "¿Eliminar docente?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Teacher", role: .destructive) {
                    deleteTeacher()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Esta acción no se puede deshacer.")
            }
            .onAppear {
                loadTeacherData()
            }
            .alert("Datos requeridos", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func loadTeacherData() {
        firstName = teacher.firstName
        lastName = teacher.lastName
        email = teacher.email
        phone = teacher.phone
        dateOfBirth = teacher.dateOfBirth
        subject = teacher.subject
        hireDate = teacher.hireDate
        isActive = teacher.isActive
    }

    private func saveChanges() {
        guard isValid else {
            alertMessage = "El nombre y apellido no pueden estar vacíos."
            showAlert = true
            return
        }

        teacher.firstName = firstName.trimmingCharacters(in: .whitespaces)
        teacher.lastName = lastName.trimmingCharacters(in: .whitespaces)
        teacher.email = email.trimmingCharacters(in: .whitespaces)
        teacher.phone = phone.trimmingCharacters(in: .whitespaces)
        teacher.dateOfBirth = dateOfBirth
        teacher.subject = subject.trimmingCharacters(in: .whitespaces)
        teacher.hireDate = hireDate
        teacher.isActive = isActive

        dismiss()
    }

    private func deleteTeacher() {
        modelContext.delete(teacher)
        dismiss()
    }
}
