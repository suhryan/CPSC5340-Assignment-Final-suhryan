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

    var body: some View {
        VStack {
            Text("My News App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            Text("Login or Signup with your email/password")
                .padding()
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
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                Button("Login") {
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
