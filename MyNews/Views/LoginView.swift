//
//  LoginView.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// user login/signup

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Login") {
                authViewModel.login(email: email, password: password)
            }
            .padding()
            Button("Sign Up") {
                authViewModel.signup(email: email, password: password)
            }
            .padding()
        }
    }
}


#Preview {
    LoginView()
}
