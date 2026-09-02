//
//  EmployeeViewModel.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

final class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAdmin: Bool = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - Real-time Listener
    func subscribeToEmployees() {
        isLoading = true
        
        listener = db.collection("employees")
            .order(by: "name")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.employees = []
                        return
                    }
                    
                    self.employees = documents.compactMap { document in
                        let data = document.data()
                        
                        guard let hrId = data["hrId"] as? String,
                              let name = data["name"] as? String,
                              let position = data["position"] as? String,
                              let department = data["department"] as? String,
                              let shift = data["shift"] as? String,
                              let phoneNumber = data["phoneNumber"] as? String,
                              let isActive = data["isActive"] as? Bool,
                              let createdAtTimestamp = data["createdAt"] as? Timestamp,
                              let updatedAtTimestamp = data["updatedAt"] as? Timestamp else {
                            return nil
                        }
                        
                        let email = data["email"] as? String
                        
                        return Employee(
                            id: document.documentID,
                            hrId: hrId,
                            name: name,
                            position: position,
                            department: department,
                            shift: shift,
                            phoneNumber: phoneNumber,
                            email: email,
                            isActive: isActive,
                            createdAt: createdAtTimestamp.dateValue(),
                            updatedAt: updatedAtTimestamp.dateValue()
                        )
                    }
                    
                    print("✅ Loaded \(self.employees.count) employees from Firebase")
                }
            }
    }
    
    // MARK: - CRUD Operations
    func addEmployee(_ employee: Employee) async throws {
        let docRef = db.collection("employees").document()
        let newEmployee = Employee(
            id: docRef.documentID,
            hrId: employee.hrId,
            name: employee.name,
            position: employee.position,
            department: employee.department,
            shift: employee.shift,
            phoneNumber: employee.phoneNumber,
            email: employee.email,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await docRef.setData(newEmployee.toDictionary())
        
        await MainActor.run {
            print("✅ Employee added: \(employee.name)")
        }
    }
    
    func updateEmployee(_ employee: Employee) async throws {
        guard let id = employee.id else { return }
        
        var updatedEmployee = employee
        updatedEmployee.updatedAt = Date()
        
        try await db.collection("employees")
            .document(id)
            .setData(updatedEmployee.toDictionary(), merge: true)
        
        await MainActor.run {
            print("✅ Employee updated: \(employee.name)")
        }
    }
    
    func deleteEmployee(_ employee: Employee) async throws {
        guard let id = employee.id else { return }
        
        try await db.collection("employees").document(id).delete()
        
        await MainActor.run {
            print("✅ Employee deleted: \(employee.name)")
        }
    }
    
    func toggleEmployeeStatus(_ employee: Employee) async throws {
        guard let id = employee.id else { return }
        
        try await db.collection("employees")
            .document(id)
            .updateData([
                "isActive": !employee.isActive,
                "updatedAt": Timestamp(date: Date())
            ])
        
        await MainActor.run {
            print("✅ Employee status toggled: \(employee.name)")
        }
    }
    
    // MARK: - Batch Import
    func batchImportEmployees(_ employees: [Employee]) async throws {
        let batch = db.batch()
        
        for employee in employees {
            let docRef = db.collection("employees").document()
            let newEmployee = Employee(
                id: docRef.documentID,
                hrId: employee.hrId,
                name: employee.name,
                position: employee.position,
                department: employee.department,
                shift: employee.shift,
                phoneNumber: employee.phoneNumber,
                email: employee.email,
                isActive: true,
                createdAt: Date(),
                updatedAt: Date()
            )
            batch.setData(newEmployee.toDictionary(), forDocument: docRef)
        }
        
        try await batch.commit()
        
        await MainActor.run {
            print("✅ Batch imported \(employees.count) employees")
        }
    }
    
    // MARK: - Cleanup
    func unsubscribe() {
        listener?.remove()
        listener = nil
    }
    
    // MARK: - Search & Filter (Client-side)
    func searchEmployees(searchText: String, department: String? = nil, shift: String? = nil) -> [Employee] {
        var filtered = employees
        
        if !searchText.isEmpty {
            filtered = filtered.filter { employee in
                employee.name.localizedCaseInsensitiveContains(searchText) ||
                employee.hrId.localizedCaseInsensitiveContains(searchText) ||
                employee.position.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let department = department, !department.isEmpty {
            filtered = filtered.filter { $0.department == department }
        }
        
        if let shift = shift, !shift.isEmpty {
            filtered = filtered.filter { $0.shift == shift }
        }
        
        return filtered
    }
    
    // MARK: - Stats
    var totalEmployees: Int {
        employees.count
    }
    
    var activeEmployees: Int {
        employees.filter { $0.isActive }.count
    }
    
    var departments: [String] {
        Array(Set(employees.map { $0.department })).sorted()
    }
    
    var shifts: [String] {
        Array(Set(employees.map { $0.shift })).sorted()
    }
}
