//
//  NetworkService.swift
//  ExziSurf
//
//  Created by Mert Köksal on 3.02.2025.
//
import Foundation

class NetworkService: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}
