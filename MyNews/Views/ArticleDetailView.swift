//
//  ArticleDetailView.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: ArticleModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display article image
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

                // Display article title
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)

                // Display article content
                Text(article.content)
                    .font(.body)
                    .padding(.bottom)

                // Link to full article
                if let url = URL(string: article.url) {
                    Link("Read Full Article", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
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
