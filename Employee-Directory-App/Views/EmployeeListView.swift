//
//  EmployeeListView.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 4/23/26.
//

import SwiftUI
import Firebase

struct EmployeeListView: View {
    @StateObject private var viewModel = EmployeeViewModel()
    @State private var searchText = ""
    @State private var selectedDepartment = "All"
    @State private var selectedShift = "All"
    @State private var showingAddEmployee = false
    
    var filteredEmployees: [Employee] {
        viewModel.searchEmployees(
            searchText: searchText,
            department: selectedDepartment == "All" ? nil : selectedDepartment,
            shift: selectedShift == "All" ? nil : selectedShift
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Stats Bar
                StatsBar(
                    total: viewModel.totalEmployees,
                    active: viewModel.activeEmployees,
                    showing: filteredEmployees.count
                )
                
                // Filter Chips
                FilterChipsView(
                    departments: viewModel.departments,
                    shifts: viewModel.shifts,
                    selectedDepartment: $selectedDepartment,
                    selectedShift: $selectedShift
                )
                
                // Employee List
                if viewModel.isLoading && viewModel.employees.isEmpty {
                    ProgressView("Loading employees...")
                        .frame(maxHeight: .infinity)
                } else if filteredEmployees.isEmpty {
                    ContentUnavailableView(
                        "No Employees Found",
                        systemImage: "person.slash",
                        description: Text("Try adjusting your search or filters")
                    )
                } else {
                    List(filteredEmployees) { employee in
                        EmployeeRowView(employee: employee, viewModel: viewModel)
                    }
                    .refreshable {
                        viewModel.unsubscribe()
                        viewModel.subscribeToEmployees()
                    }
                }
            }
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search by ID, name, or position")
            .toolbar {
                // Right side - Add Employee Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddEmployee = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEmployee) {
                AddEmployeeView(viewModel: viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.subscribeToEmployees()
            }
            .onDisappear {
                viewModel.unsubscribe()
            }
        }
    }
}

// MARK: - Stats Bar
struct StatsBar: View {
    let total: Int
    let active: Int
    let showing: Int
    
    var body: some View {
        HStack {
            StatBadge(title: "Total", value: total, color: .blue)
            StatBadge(title: "Active", value: active, color: .green)
            StatBadge(title: "Showing", value: showing, color: .orange)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

struct StatBadge: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title + ":")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
}

// MARK: - Filter Chips
struct FilterChipsView: View {
    let departments: [String]
    let shifts: [String]
    @Binding var selectedDepartment: String
    @Binding var selectedShift: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Department filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All Departments", isSelected: selectedDepartment == "All") {
                        selectedDepartment = "All"
                    }
                    
                    ForEach(departments, id: \.self) { department in
                        FilterChip(title: department, isSelected: selectedDepartment == department) {
                            selectedDepartment = department
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Shift filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All Shifts", isSelected: selectedShift == "All") {
                        selectedShift = "All"
                    }
                    
                    ForEach(shifts, id: \.self) { shift in
                        FilterChip(title: shift, isSelected: selectedShift == shift) {
                            selectedShift = shift
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
