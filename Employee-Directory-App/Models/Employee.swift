//
//  Employee.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import Foundation
import FirebaseFirestore

struct Employee: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore manages this - never set it manually
    var hrId: String
    var name: String
    var position: String
    var department: String
    var shift: String
    var phoneNumber: String
    var email: String?
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case hrId
        case name
        case position
        case department
        case shift
        case phoneNumber
        case email
        case isActive
        case createdAt
        case updatedAt
    }
    
    // Initialize new employee (without ID - Firestore will add it)
    init(hrId: String, name: String, position: String, department: String,
         shift: String, phoneNumber: String = "", email: String? = nil) {
        self.id = nil  // Don't set this - Firestore will set it
        self.hrId = hrId
        self.name = name
        self.position = position
        self.department = department
        self.shift = shift
        self.phoneNumber = phoneNumber
        self.email = email
        self.isActive = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Initialize from Firestore (with ID already set by Firestore)
    init(id: String, hrId: String, name: String, position: String,
         department: String, shift: String, phoneNumber: String,
         email: String?, isActive: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.hrId = hrId
        self.name = name
        self.position = position
        self.department = department
        self.shift = shift
        self.phoneNumber = phoneNumber
        self.email = email
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Firestore Conversion
extension Employee {
    func toDictionary() -> [String: Any] {
        return [
            "hrId": hrId,
            "name": name,
            "position": position,
            "department": department,
            "shift": shift,
            "phoneNumber": phoneNumber,
            "email": email ?? "",
            "isActive": isActive,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
}
