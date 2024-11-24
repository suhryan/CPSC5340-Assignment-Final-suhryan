//
//  AuthViewModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// Authentication logic and state

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String? //error messages during login/signup
    @Published var topicSearch = "" // Track the topic entered in LoginView

    // set initial login state
    init() {
        isSignedIn = Auth.auth().currentUser != nil
    }

    //Use Firebase Authentication to log in with email and password
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    print("Error code: \(error.code), Message: \(error.localizedDescription)")
                    if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                        switch authErrorCode {
                        case .wrongPassword:
                            self?.errorMessage = "Incorrect password. Please try again."
                        case .invalidEmail:
                            self?.errorMessage = "Invalid email format. Please check and try again."
                        case .userNotFound:
                            self?.errorMessage = "No account found for this email. Please sign up first."
                        default:
                            self?.errorMessage = "Authentication error. Please check your email and password."
                        }
                    } else {
                        self?.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    }
                } else {
                    self?.isSignedIn = true
                    self?.errorMessage = nil
                }
            }
        }
    }

    //Creates a new user using Firebase Authentication
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
    
    //Log out the user using Firebase Authentication
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
                self.topicSearch = "" // Reset the topic search on logout
                self.errorMessage = nil //to clear LoginView display of error
            }
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

