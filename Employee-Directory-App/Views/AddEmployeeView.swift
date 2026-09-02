//
//  AddEmployeeView.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import SwiftUI

struct AddEmployeeView: View {
    @ObservedObject var viewModel: EmployeeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var hrId = ""
    @State private var name = ""
    @State private var position = ""
    @State private var department = ""
    @State private var shift = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var isSubmitting = false
    
    let departments = ["Production", "Loading", "Washline", "QC", "Sanitation",
                       "Maintenance", "Cold Storage", "Shipping", "Housekeeping", "Front Office"]
    let shifts = ["1st (6am-2pm)", "2nd (2pm-10pm)", "3rd (10pm-6am)",
                  "1st (3:30am-12pm)", "2nd (3:30pm-12am)", "3rd (9pm-5am)"]
    
    var isFormValid: Bool {
        !hrId.isEmpty && !name.isEmpty && !position.isEmpty &&
        !department.isEmpty && !shift.isEmpty && !phoneNumber.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Employee ID") {
                    TextField("HR ID or Number", text: $hrId)
                        .textInputAutocapitalization(.never)
                }
                
                Section("Personal Information") {
                    TextField("Full Name", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Position", text: $position)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Department & Shift") {
                    Picker("Department", selection: $department) {
                        Text("Select").tag("")
                        ForEach(departments, id: \.self) { dept in
                            Text(dept).tag(dept)
                        }
                    }
                    
                    Picker("Shift", selection: $shift) {
                        Text("Select").tag("")
                        ForEach(shifts, id: \.self) { s in
                            Text(s).tag(s)
                        }
                    }
                }
                
                Section("Contact") {
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    TextField("Email (Optional)", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Employee")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        submitEmployee()
                    }
                    .disabled(!isFormValid || isSubmitting)
                }
            }
            .overlay {
                if isSubmitting {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay(ProgressView())
                }
            }
        }
    }
    
    private func submitEmployee() {
        isSubmitting = true
        
        let newEmployee = Employee(
            hrId: hrId,
            name: name,
            position: position,
            department: department,
            shift: shift,
            phoneNumber: phoneNumber,
            email: email.isEmpty ? nil : email
        )
        
        Task {
            do {
                try await viewModel.addEmployee(newEmployee)
                isSubmitting = false
                dismiss()
            } catch {
                isSubmitting = false
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }
}
