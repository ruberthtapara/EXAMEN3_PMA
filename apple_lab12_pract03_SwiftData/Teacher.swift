//
//  Teacher.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import Foundation
import SwiftData

@Model
final class Teacher {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var dateOfBirth: Date
    var subject: String
    var hireDate: Date
    var isActive: Bool

    init(
        id: UUID = UUID(),
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        phone: String = "",
        dateOfBirth: Date = Date(),
        subject: String = "",
        hireDate: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.subject = subject
        self.hireDate = hireDate
        self.isActive = isActive
    }

    var fullName: String {
        let combined = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        return combined.isEmpty ? "Sin nombre" : combined
    }

    var initials: String {
        let f = firstName.trimmingCharacters(in: .whitespaces).first.map { String($0) } ?? ""
        let l = lastName.trimmingCharacters(in: .whitespaces).first.map { String($0) } ?? ""
        let res = (f + l).uppercased()
        return res.isEmpty ? "?" : res
    }
}
