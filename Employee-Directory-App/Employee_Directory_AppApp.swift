//
//  Employee_Directory_AppApp.swift
//  Employee-Directory-App
//
//  Created by Jorge Contreras Jr on 8/30/26.
//

import SwiftUI
import FirebaseCore

@main
struct Employee_Directory_AppApp: App {
    
    init (){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            EmployeeListView()
        }
    }
}
