//
//  AddTeacherView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import SwiftUI
import SwiftData

struct AddTeacherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()

    @State private var subject: String = ""
    @State private var hireDate: Date = Date()
    @State private var isActive: Bool = true

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
                        TextField("Subject / Specialty (e.g. Java Senior)", text: $subject)
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
            }
            .navigationTitle("Add Teacher")
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
                        saveTeacher()
                    }
                    .fontWeight(.bold)
                    .disabled(!isValid)
                }
            }
            .tint(.indigo)
            .alert("Datos requeridos", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func saveTeacher() {
        guard isValid else {
            alertMessage = "Por favor ingrese el nombre y apellido del docente."
            showAlert = true
            return
        }

        let newTeacher = Teacher(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth,
            subject: subject.trimmingCharacters(in: .whitespaces),
            hireDate: hireDate,
            isActive: isActive
        )

        modelContext.insert(newTeacher)
        dismiss()
    }
}
