//
//  WeatherAPIService.swift
//  ExziSurf
//
//  Created by Mert Köksal on 3.02.2025.
//

import Foundation

class WeatherAPIService: WeatherServiceProtocol {
    private let apiKey = "a7bc966cca5a4a358afd4e95d84c432a"
    private let baseURL = "https://api.weatherbit.io/v2.0/forecast/hourly"
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchWeather(for city: String, countryCode: String) async throws -> WeatherAPIResponse {
        let cityWithCountry = "\(city),\(countryCode)"
        guard let encodedCityWithCountry = cityWithCountry.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        guard let url = URL(string: "\(baseURL)?city=\(encodedCityWithCountry)&key=\(apiKey)&hours=48") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            
            // Print the raw data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            // Try to decode the response into the expected model
            let response = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            
            // Check if city_name and country_code are non-empty strings
            if response.city_name.isEmpty || response.country_code.isEmpty {
                throw WeatherAPIError.invalidData
            }
            
            return response
            
        } catch {
            print("Error occurred: \(error.localizedDescription)")
            throw error
        }
    }


}
