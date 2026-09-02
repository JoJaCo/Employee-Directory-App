//
//  EmployeeRowView.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import SwiftUI

struct EmployeeRowView: View {
    let employee: Employee
    // ✅ Instead of passing whole ViewModel, pass only what's needed
    let onDelete: () async -> Void
    let onToggleStatus: () async -> Void
    let onPhoneTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(employee.hrId)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                
                if !employee.isActive {
                    Text("Inactive")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            
            Text(employee.name)
                .font(.headline)
            
            Text(employee.position)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(employee.department, systemImage: "building.2")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Label(employee.shift, systemImage: "clock")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Capsule())
            }
            
            if !employee.phoneNumber.isEmpty {
                HStack {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text(employee.formattedPhoneNumber)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    onPhoneTap()
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task {
                    await onDelete()
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                Task {
                    await onToggleStatus()
                }
            } label: {
                Label(employee.isActive ? "Deactivate" : "Activate",
                      systemImage: employee.isActive ? "person.slash" : "person.fill.checkmark")
            }
            .tint(employee.isActive ? .orange : .green)
        }
    }
}

// MARK: - Equatable for Performance
extension EmployeeRowView: Equatable {
    static func == (lhs: EmployeeRowView, rhs: EmployeeRowView) -> Bool {
        lhs.employee.id == rhs.employee.id &&
        lhs.employee.isActive == rhs.employee.isActive &&
        lhs.employee.phoneNumber == rhs.employee.phoneNumber
    }
}

