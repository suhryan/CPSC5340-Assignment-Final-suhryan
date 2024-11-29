//
//  ArticleDetailView.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: ArticleModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Article Image
                if let url = URL(string: article.imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.bottom)
                    } placeholder: {
                        Color.gray
                            .frame(height: 200)
                            .padding(.bottom)
                    }
                }

                // Article Title
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)

                // Article Content
                Text(article.content)
                    .font(.body)
                    .padding(.bottom)

                // Link to Full Article
                if let url = URL(string: article.url) {
                    Link("Read Full Article", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top)
                }

                // Bookmark Button
                Button(action: {
                    authViewModel.addBookmark(article)
                }) {
                    Text(authViewModel.bookmarks.contains(where: { $0.id == article.id }) ? "Already Bookmarked" : "Bookmark Article")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(authViewModel.bookmarks.contains(where: { $0.id == article.id }) ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.top)
                }
                .disabled(authViewModel.bookmarks.contains(where: { $0.id == article.id })) // Disable if already bookmarked
            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


/*
#Preview {
    ArticleDetailView()
}
*/
