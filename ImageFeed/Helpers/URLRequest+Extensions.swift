//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 07.09.2023.
//

import Foundation

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
