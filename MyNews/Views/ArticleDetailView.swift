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

                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)

                Text(article.content)
                    .font(.body)
                    .padding(.bottom)

                if let url = URL(string: article.url) {
                    Link("Read Full Article", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top)
                }

                Button(action: {
                    authViewModel.addBookmark(article)
                }) {
                    Text("Bookmark Article")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top)
                }
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
