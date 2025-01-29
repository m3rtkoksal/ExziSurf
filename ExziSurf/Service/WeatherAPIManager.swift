//
//  WeatherAPIManager.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import Foundation

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

// Define the protocol
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Conform URLSession to the protocol
extension URLSession: URLSessionProtocol {}

class WeatherAPIManager: ObservableObject {
    private let apiKey = "a7bc966cca5a4a358afd4e95d84c432a"
    private let baseURL = "https://api.weatherbit.io/v2.0/forecast/hourly"
    private let urlSession: URLSessionProtocol
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var weatherData: [WeatherData] = []
    @Published var optimalSurfingTimes: [SurfingTime] = []
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    // Fetch weather data for a given city and country code
    func fetchWeather(for city: String, countryCode: String) async {
        let cityWithCountry = "\(city),\(countryCode)"
        
        // Construct the URL
        guard let url = URL(string: "\(baseURL)?city=\(cityWithCountry)&key=\(apiKey)&hours=48") else {
            print("Invalid URL")
            return
        }
        
        // Perform the network request
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the response using the updated model
            let decodedResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            
            // Assign the weather data to the published variable
            await MainActor.run {
                self.weatherData = decodedResponse.data
                self.city = decodedResponse.city_name
                self.country = decodedResponse.country_code
            }
            
            print("Requested weather city: \(self.city)")
            print("Requested weather country: \(self.country)")
            // Now that the weather data is fetched, calculate the optimal surfing times
            let optimalTimes = getOptimalSurfingTimes()
          
            await MainActor.run {
                self.optimalSurfingTimes = optimalTimes
            }
            
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    // Function to calculate surfing score for each hour
    func calculateSurfingScore(weather: WeatherData) -> Double {
        // Calculate wind score based on wind speed
        let windScore = 18 - abs(weather.wind_spd - 12)
        
        // Calculate temperature score based on temperature
        let tempScore = 35 - abs(weather.temp - 20)
        
        // Combine wind and temperature scores into the final surfing score
        let surfingScore = (windScore + tempScore) / 2.0
        
        // Ensure the score is between 0 and 100
        let clampedScore = min(max(surfingScore, 0), 100)
        
        return clampedScore
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
        let filteredTimes = weatherData.map { weather in
            // Convert the datetime string to Date
            let datetime = parseDatetimeString(datetimeString: weather.datetime)
            
            // Calculate the surfing score using the new formula
            let score = calculateSurfingScore(weather: weather)
            
            // Return the SurfingTime with the Date (instead of string)
            return SurfingTime(datetime: datetime, score: score)
        }
        .filter { timeRange in
            // Only include the times that fall between 6 AM and 6 PM
            let time = getHourFromDatetime(datetime: timeRange.datetime)
            return time >= 6 && time <= 18
        }
        .sorted { a, b in
            // Sort by highest surfing score
            return a.score > b.score
        }
        return filteredTimes
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
