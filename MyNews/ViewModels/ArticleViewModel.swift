//
//  ArticleViewModel.swift
//  MyNews
//
//  Created by ryan suh on 11/23/24.
//
// API key from newsapi.org

import Foundation

class ArticleViewModel: ObservableObject {
    @Published var articles: [ArticleModel] = []
    @Published var errorMessage: String?
    private let apiKey = "11ca150283fe45a3a8746de0a829b7a1"

    /// Fetch articles based on the given topics
    func fetchArticles(for topics: [String]) {
        guard !topics.isEmpty else {
            self.errorMessage = "No topics provided."
            return
        }
        
        // Combine topics into a single query string
        let query = topics.joined(separator: " OR ")
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL."
            return
        }

        // Make a network request
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error fetching articles: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received from API."
                }
                return
            }

            do {
                // Decode the JSON response
                let decodedResponse = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    // Map the API articles to our ArticleModel
                    self?.articles = decodedResponse.articles.map { article in
                        ArticleModel(
                            id: UUID().uuidString,
                            title: article.title,
                            content: article.description ?? "No content available.",
                            topic: query,
                            url: article.url,
                            imageURL: article.urlToImage ?? ""
                        )
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct NewsAPIResponse: Codable {
    let articles: [NewsAPIArticle]
}

struct NewsAPIArticle: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
}
