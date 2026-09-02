//
//  SplashView.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras on 9/2/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            VStack(spacing: 20) {
                // Logo
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                }
                
                Text("Employee Directory")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Loading...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
