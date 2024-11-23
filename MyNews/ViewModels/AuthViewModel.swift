//
//  AuthViewModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// authentication logic

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignedIn = true
                }
            }
        }
    }

    func signup(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignedIn = true
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
