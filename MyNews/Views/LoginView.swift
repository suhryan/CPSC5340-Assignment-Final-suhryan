//
//  LoginView.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// Login/signup view

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var searchTopic = "" // For topic search

    var body: some View {
        VStack {
            Text("My News")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
            Text("Personalized News Hub")
            Text("view headliners,")
            Text("search topics,")
            Text("add/delete bookmarks")
            Spacer()
            Spacer()

            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Search Topic (Optional)", text: $searchTopic)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Login") {
                    authViewModel.topicSearch = searchTopic.trimmingCharacters(in: .whitespaces)
                    authViewModel.login(email: email, password: password)
                }
                .padding()

                Button("Sign Up") {
                    authViewModel.signup(email: email, password: password)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
