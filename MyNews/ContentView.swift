//
//  ContentView.swift
//  MyNews
//
//  Created by ryan suh on 11/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
                LoginView() // The login/signup screen for authentication
                    .environmentObject(authViewModel)
        }
    }
}


#Preview {
    ContentView()
}
