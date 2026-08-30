
//
//  EmployeeDataLoader.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import Foundation
import FirebaseFirestore

struct EmployeeDataLoader {
    
    static func getAllEmployees() -> [[String: Any]] {
        var employees: [[String: Any]] = []
        
        // Add your employee data here
        employees.append(contentsOf: [
            createEmployee(hrId: "4024", name: "AGUILAR MORALES, ROCKY", position: "Stacker", department: "Production", shift: "1st (6am-2pm)", phone: "6618663319"),
            createEmployee(hrId: "4397", name: "ORTIZ, PAOLA", position: "Operator Level 1", department: "Production", shift: "1st (6am-2pm)", phone: "6618895937"),
            createEmployee(hrId: "5487", name: "MEZA, ROGELIO", position: "Operator Level 1", department: "Production", shift: "1st (6am-2pm)", phone: "5624154923"),
            createEmployee(hrId: "6038", name: "DIAZ PEREZ, DAVID", position: "Stacker", department: "Production", shift: "1st (6am-2pm)", phone: "8027823460"),
            createEmployee(hrId: "HR107953", name: "ROSA PALMA", position: "Grader", department: "Production", shift: "1st (6am-2pm)", phone: "7145861072"),
            createEmployee(hrId: "4462", name: "GONZALEZ, SANDRA", position: "Grader", department: "Production", shift: "1st (6am-2pm)", phone: "6618059423"),
            createEmployee(hrId: "HR128673", name: "MARIA CORONA REYES", position: "MO", department: "Production", shift: "1st (6am-2pm)", phone: "6613425189"),
            createEmployee(hrId: "HR129206", name: "EMMANUEL MARTINES", position: "Stand Up FL", department: "Production", shift: "1st (6am-2pm)", phone: "6613144304"),
            createEmployee(hrId: "HR106928", name: "JOSE NARANJO PEREZ", position: "FL", department: "Production", shift: "1st (6am-2pm)", phone: "6615566718")
        ])
        
        return employees
    }
    
    private static func createEmployee(hrId: String, name: String, position: String, department: String, shift: String, phone: String) -> [String: Any] {
        return [
            "hrId": hrId,
            "name": name,
            "position": position,
            "department": department,
            "shift": shift,
            "phoneNumber": phone,
            "email": "",
            "isActive": true,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
    }
}
