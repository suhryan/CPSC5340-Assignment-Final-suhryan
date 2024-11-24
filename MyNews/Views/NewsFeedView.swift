//
//  NewsFeedView.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var articleViewModel = ArticleViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel // Access the authentication view model

    var body: some View {
        VStack {
            if let errorMessage = articleViewModel.errorMessage {
                // Display error message if something goes wrong
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            List(articleViewModel.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    HStack {
                        AsyncImage(url: URL(string: article.imageURL)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        } placeholder: {
                            Color.gray
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(article.topic)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            articleViewModel.fetchArticles(for: ["technology", "science"]) // Example topics
        }
        .navigationTitle("News Feed")
        .navigationBarTitleDisplayMode(.inline) // Ensure single title display
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    authViewModel.logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    NewsFeedView()
}
