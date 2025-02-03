//
//  WeatherAPIManager.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import Foundation

enum WeatherAPIError: Error {
    case networkError
    case invalidData
    case cityNotFound
    case unknownError
}

struct WeatherAPIResponse: Decodable {
    let city_name: String
    let country_code: String
    let data: [WeatherData]
}

struct WeatherData: Decodable {
    let app_temp: Double
    let clouds: Int
    let datetime: String
    let temp: Double
    let wind_spd: Double
    let weather: WeatherCondition
}

struct WeatherCondition: Decodable {
    let icon: String
    let description: String
    let code: Int
}

struct SurfingTime: Identifiable {
    var id: String { datetime.description }
    var datetime: Date
    var score: Double
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, countryCode: String) async throws -> WeatherAPIResponse
}

// Define the protocol
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Conform URLSession to the protocol
extension URLSession: URLSessionProtocol {}

class WeatherAPIManager: ObservableObject {
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var weatherData: [WeatherData] = []
    @Published var optimalSurfingTimes: [SurfingTime] = []
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String, countryCode: String) async throws {
        do {
            let response = try await weatherService.fetchWeather(for: city, countryCode: countryCode)
            
            guard !response.data.isEmpty, !response.city_name.isEmpty, !response.country_code.isEmpty else {
                throw WeatherAPIError.invalidData
            }
            
            await MainActor.run {
                self.weatherData = response.data
                self.city = response.city_name
                self.country = response.country_code
            }
            
            let optimalTimes = getOptimalSurfingTimes()
            await MainActor.run {
                self.optimalSurfingTimes = optimalTimes
            }
            
        } catch let error as URLError {
            // Handle specific network-related errors
            switch error.code {
            case .notConnectedToInternet:
                throw WeatherAPIError.networkError
            case .timedOut:
                throw WeatherAPIError.networkError
            default:
                throw WeatherAPIError.networkError
            }
        } catch {
            // Handle any other error, such as decoding errors or general network errors
            throw WeatherAPIError.networkError
        }
    }

    // Function to calculate surfing score for each hour
    func calculateSurfingScore(weather: WeatherData) -> Double {
        let windScore = 18 - abs(weather.wind_spd - 12)
        let tempScore = 35 - abs(weather.temp - 20)
        return min(max((windScore + tempScore) / 2.0, 0), 100)
    }
    
    private func getWindSpeedScore(windSpeed: Double, idealRange: ClosedRange<Double>) -> Double {
        // Return score between 0 and 100
        if windSpeed < idealRange.lowerBound || windSpeed > idealRange.upperBound {
            return 0
        }
        let middleOfRange = (idealRange.lowerBound + idealRange.upperBound) / 2
        return 100 - abs((windSpeed - middleOfRange) / (idealRange.upperBound - idealRange.lowerBound)) * 100
    }
    
    private func getTemperatureScore(temperature: Double, idealRange: ClosedRange<Double>) -> Double {
        // Return score between 0 and 100
        if temperature < idealRange.lowerBound || temperature > idealRange.upperBound {
            return 0
        }
        let middleOfRange = (idealRange.lowerBound + idealRange.upperBound) / 2
        return 100 - abs((temperature - middleOfRange) / (idealRange.upperBound - idealRange.lowerBound)) * 100
    }
    
    func getOptimalSurfingTimes() -> [SurfingTime] {
        weatherData
            .filter { [800, 801, 802].contains($0.weather.code) }
            .map { weather in
                let datetime = parseDatetimeString(datetimeString: weather.datetime)
                let score = calculateSurfingScore(weather: weather)
                return SurfingTime(datetime: datetime, score: score)
            }
            .filter { 6...18 ~= getHourFromDatetime(datetime: $0.datetime) }
            .sorted { $0.score > $1.score }
    }
    
    func parseDatetimeString(datetimeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd:HH"
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: datetimeString) {
            return date
        } else {
            print("Error parsing datetime string: \(datetimeString)")
            return Date() // Fallback to current date if parsing fails
        }
    }
    
    func formatDateToString(datetime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd:HH"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: datetime)
    }
    
    func getHourFromDatetime(datetime: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: TimeZone.current, from: datetime)
        return components.hour ?? 0
    }
}

class MockWeatherService: WeatherServiceProtocol {
    func fetchWeather(for city: String, countryCode: String) async throws -> WeatherAPIResponse {
        return WeatherAPIResponse(
            city_name: city,
            country_code: countryCode,
            data: [WeatherData(app_temp: 22, clouds: 10, datetime: "2025-02-03:12", temp: 21, wind_spd: 10, weather: WeatherCondition(icon: "c01d", description: "Clear", code: 800))]
        )
    }
}
