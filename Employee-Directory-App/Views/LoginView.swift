//
//  LoginView.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 9/2/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // MARK: - Logo Section
                    VStack(spacing: 12) {
                        // Company Logo Placeholder
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        }
                        
                        Text("Employee Directory")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Access your team's information")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // MARK: - Login Form
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                TextField("Enter your email", text: $email)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Sign In Button
                    Button {
                        // For now, just navigate to employee list
                        isLoggedIn = true
                    } label: {
                        HStack {
                            Text("Sign In")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                    
                    // MARK: - Forgot Password
                    Button("Forgot Password?") {
                        // TODO: Add forgot password logic
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    // MARK: - Demo Mode Button
                    VStack {
                        Divider()
                            .padding(.horizontal)
                        
                        Button {
                            isLoggedIn = true
                        } label: {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                Text("Continue as Demo User")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                EmployeeListView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LoginView()
}
