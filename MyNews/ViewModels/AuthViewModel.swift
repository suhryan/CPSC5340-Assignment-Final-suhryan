//
//  AuthViewModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// Authentication logic and state

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String? // Error messages during login/signup
    @Published var topicSearch = "" // Track the topic entered in LoginView
    @Published var bookmarks: [ArticleModel] = [] // User's bookmarks

    private let db = Firestore.firestore()

    init() {
        isSignedIn = Auth.auth().currentUser != nil
        if let userID = Auth.auth().currentUser?.uid {
            fetchBookmarks(userID: userID)
        }
    }


    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    self?.handleAuthError(error)
                } else if let userID = result?.user.uid {
                    self?.initializeUserDocumentIfMissing(userID: userID) // Reinitialize if missing
                    self?.fetchBookmarks(userID: userID) // Fetch bookmarks
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
                } else if let userID = result?.user.uid {
                    self?.initializeUserDocument(userID: userID) // Create user document
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
                self.bookmarks = []
                self.topicSearch = ""
                self.errorMessage = nil
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func addBookmark(_ article: ArticleModel) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        // Check if the article is already bookmarked
        if bookmarks.contains(where: { $0.id == article.id }) {
            print("Article is already bookmarked. Skipping...")
            return
        }

        let userDocRef = db.collection("users").document(userID)
        let articleDocRef = db.collection("articles").document(article.id)

        // Add the article ID to the user's bookmarks array
        userDocRef.updateData([
            "bookmarks": FieldValue.arrayUnion([article.id])
        ]) { [weak self] error in
            if let error = error {
                print("Error adding bookmark: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self?.bookmarks.append(article)
                    print("Bookmark added successfully.")
                }
            }
        }

        // Save article details in the `articles` collection if not already present
        articleDocRef.setData([
            "id": article.id,
            "title": article.title,
            "content": article.content,
            "topic": article.topic,
            "url": article.url,
            "imageURL": article.imageURL
        ], merge: true) { error in
            if let error = error {
                print("Error saving article details: \(error.localizedDescription)")
            } else {
                print("Article saved in Firestore successfully.")
            }
        }
    }


    func removeBookmark(_ article: ArticleModel) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let userDocRef = db.collection("users").document(userID)
        //let articleDocRef = db.collection("articles").document(article.id)

        // Step 1: Remove the article ID from the user's bookmarks array
        userDocRef.updateData([
            "bookmarks": FieldValue.arrayRemove([article.id])
        ]) { [weak self] error in
            if let error = error {
                print("Error removing bookmark from user: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    // Remove the article from the local bookmarks array
                    self?.bookmarks.removeAll { $0.id == article.id }
                    print("Bookmark removed from user successfully.")
                }

                // Step 2: Check if the article is still bookmarked by other users
                self?.checkAndDeleteArticleIfUnreferenced(article: article)
            }
        }
    }

    // Helper function to delete the article document if it is no longer referenced
    private func checkAndDeleteArticleIfUnreferenced(article: ArticleModel) {
        let usersCollection = db.collection("users")

        // Query all users to check if the article is still referenced in any bookmarks
        usersCollection.whereField("bookmarks", arrayContains: article.id).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking article references: \(error.localizedDescription)")
                return
            }

            // If no user references the article, delete it from the `articles` collection
            if let documents = snapshot?.documents, documents.isEmpty {
                self.deleteArticleFromArticlesCollection(article: article)
            }
        }
    }

    // Helper function to delete the article from the `articles` collection
    private func deleteArticleFromArticlesCollection(article: ArticleModel) {
        let articleDocRef = db.collection("articles").document(article.id)

        articleDocRef.delete { error in
            if let error = error {
                print("Error deleting article from articles collection: \(error.localizedDescription)")
            } else {
                print("Article deleted from articles collection successfully.")
            }
        }
    }

    func fetchBookmarks(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        userDocRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching bookmarks: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(),
                  let bookmarkIDs = data["bookmarks"] as? [String], !bookmarkIDs.isEmpty else {
                DispatchQueue.main.async {
                    self?.bookmarks = [] // No bookmarks
                }
                print("No bookmarks found for user.")
                return
            }

            self?.fetchArticlesFromIDs(bookmarkIDs)
        }
    }

    private func fetchArticlesFromIDs(_ ids: [String]) {
        db.collection("articles").whereField("id", in: ids).getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching bookmarked articles: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self?.bookmarks = snapshot?.documents.compactMap { document in
                    try? document.data(as: ArticleModel.self)
                } ?? []
                print("Fetched bookmarks: \(self?.bookmarks.count ?? 0) articles.")
            }
        }
    }
/*
    private func initializeUserDocument(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        userDocRef.setData([
            "bookmarks": []
        ]) { error in
            if let error = error {
                print("Error initializing user document: \(error.localizedDescription)")
            }
        }
    }
*/
    func initializeUserDocument(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        userDocRef.setData([
            "email": Auth.auth().currentUser?.email ?? "", // Email is saved here
            "bookmarks": [],
            "createdAt": FieldValue.serverTimestamp() // CreatedAt is set here
        ]) { error in
            if let error = error {
                print("Error initializing user document: \(error.localizedDescription)")
            } else {
                print("User document initialized successfully.")
            }
        }
    }
/*
    private func initializeUserDocumentIfMissing(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("User document already exists")
            } else {
                self.initializeUserDocument(userID: userID)
            }
        }
    }
*/
    func initializeUserDocumentIfMissing(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error checking user document: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                print("User document already exists.")
            } else {
                print("User document is missing. Reinitializing...")
                self.initializeUserDocument(userID: userID)
            }
        }
    }

    private func handleAuthError(_ error: NSError) {
        if let authErrorCode = AuthErrorCode(rawValue: error.code) {
            switch authErrorCode {
            case .wrongPassword:
                errorMessage = "Incorrect password. Please try again."
            case .invalidEmail:
                errorMessage = "Invalid email format. Please check and try again."
            case .userNotFound:
                errorMessage = "No account found for this email. Please sign up first."
            default:
                errorMessage = "Authentication error. Please check your email and password."
            }
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
