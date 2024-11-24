//
//  ContentView.swift
//  MyNews
//
//  Created by ryan suh on 11/22/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            if authViewModel.isSignedIn {
                NewsFeedView() // Main content: News Feed
                    .environmentObject(authViewModel)
            } else {
                LoginView() // Authentication screen
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.isSignedIn = Auth.auth().currentUser != nil
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Optimized for single-column navigation
    }
}

#Preview {
    ContentView()
}
