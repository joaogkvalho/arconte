//
//  APIError.swift
//  arconte
//
//  Created by Joao Gabriel Carvalho on 09/11/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .httpError(let statusCode):
            return "The server returned an HTTP error: \(statusCode)."

        case .decodingError(let error):
            return "Failed to decode the server response: \(error.localizedDescription)"

        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        }
    }
}
