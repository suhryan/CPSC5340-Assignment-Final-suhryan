//
//  MyNewsApp.swift
//  MyNews
//
//  Created by ryan suh on 11/22/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MyNewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel() // Initialize here

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel) // Pass it to the view hierarchy
        }
    }
}
