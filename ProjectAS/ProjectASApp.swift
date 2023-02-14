//
//  ProjectASApp.swift
//  ProjectAS
//
//  Created by Eric Johansson & Can Kupeli on 2023-02-07.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct ProjectASApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
