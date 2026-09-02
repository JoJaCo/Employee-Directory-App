//
//  Employee.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import Foundation
import FirebaseFirestore

struct Employee: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
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
    
    // Initialize new employee
    init(hrId: String, name: String, position: String, department: String,
         shift: String, phoneNumber: String = "", email: String? = nil) {
        self.id = nil
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
    
    // Initialize from Firestore
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
    
    // MARK: - Equatable
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id &&
        lhs.hrId == rhs.hrId &&
        lhs.name == rhs.name &&
        lhs.position == rhs.position &&
        lhs.department == rhs.department &&
        lhs.shift == rhs.shift &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.email == rhs.email &&
        lhs.isActive == rhs.isActive
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

// MARK: - Phone Number Formatting
extension Employee {
    var formattedPhoneNumber: String {
        if phoneNumber.contains("-") || phoneNumber.contains("(") {
            return phoneNumber
        }
        
        let cleaned = phoneNumber.filter { $0.isNumber }
        if cleaned.count == 10 {
            return "(\(cleaned.prefix(3))) \(cleaned.dropFirst(3).prefix(3))-\(cleaned.suffix(4))"
        } else if cleaned.count == 7 {
            return "\(cleaned.prefix(3))-\(cleaned.suffix(4))"
        }
        return phoneNumber
    }
}
