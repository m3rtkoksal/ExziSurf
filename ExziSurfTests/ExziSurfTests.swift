//
//  ExziSurfTests.swift
//  ExziSurfTests
//
//  Created by Mert Köksal on 29.01.2025.
//

import XCTest
@testable import ExziSurf

// Mock URLSession for testing
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), URLResponse())
    }
}

final class ExziSurfTests: XCTestCase {

    var weatherAPIManager: WeatherAPIManager!

    override func setUpWithError() throws {
        // Initialize the WeatherAPIManager with a mock URLSession
        let mockSession = MockURLSession()
        weatherAPIManager = WeatherAPIManager(urlSession: mockSession)
    }

    override func tearDownWithError() throws {
        // Clean up after each test
        weatherAPIManager = nil
    }

    // Test successful weather data fetch
    func testFetchWeather_Success() async {
        // Mock URLSession
        let mockSession = MockURLSession()
        mockSession.data = """
        {
            "city_name": "Sydney",
            "country_code": "AU",
            "data": [
                {
                    "app_temp": 20.5,
                    "clouds": 10,
                    "datetime": "2023-10-01:12",
                    "temp": 22.0,
                    "wind_spd": 12.0,
                    "weather": {
                        "icon": "c01d",
                        "description": "Clear sky",
                        "code": 800
                    }
                }
            ]
        }
        """.data(using: .utf8)
        
        // Inject the mock session into the WeatherAPIManager
        weatherAPIManager = WeatherAPIManager(urlSession: mockSession)
        
        // Fetch weather data
        await weatherAPIManager.fetchWeather(for: "Sydney", countryCode: "AU")
        
        // Assert that the weather data is correctly populated
        XCTAssertEqual(weatherAPIManager.weatherData.count, 1)
        XCTAssertEqual(weatherAPIManager.weatherData.first?.temp, 22.0)
        XCTAssertEqual(weatherAPIManager.weatherData.first?.wind_spd, 12.0)
    }

    // Test handling of invalid URL
    func testFetchWeather_InvalidURL() async {
        // Mock URLSession to simulate an error
        let mockSession = MockURLSession()
        mockSession.error = NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        
        // Inject the mock session into the WeatherAPIManager
        weatherAPIManager = WeatherAPIManager(urlSession: mockSession)
        
        // Fetch weather data with an invalid URL
        await weatherAPIManager.fetchWeather(for: "", countryCode: "")
        
        // Assert that the weather data is empty
        XCTAssertTrue(weatherAPIManager.weatherData.isEmpty)
    }

    // Test calculation of optimal surfing times
    func testGetOptimalSurfingTimes() {
        // Create mock weather data
        let mockWeatherData = [
            WeatherData(app_temp: 20.0, clouds: 10, datetime: "2023-10-01:06", temp: 22.0, wind_spd: 12.0, weather: WeatherCondition(icon: "c01d", description: "Clear sky", code: 800)),
            WeatherData(app_temp: 25.0, clouds: 20, datetime: "2023-10-01:12", temp: 25.0, wind_spd: 10.0, weather: WeatherCondition(icon: "c02d", description: "Partly cloudy", code: 801)),
            WeatherData(app_temp: 18.0, clouds: 30, datetime: "2023-10-01:18", temp: 18.0, wind_spd: 15.0, weather: WeatherCondition(icon: "c03d", description: "Cloudy", code: 802)),
            WeatherData(app_temp: 15.0, clouds: 40, datetime: "2023-10-01:20", temp: 15.0, wind_spd: 20.0, weather: WeatherCondition(icon: "c04d", description: "Overcast", code: 803))
        ]
        
        // Assign mock data to the weatherAPIManager
        weatherAPIManager.weatherData = mockWeatherData
        
        // Get optimal surfing times
        let optimalTimes = weatherAPIManager.getOptimalSurfingTimes()
        
        // Assert that the optimal times are correctly filtered and ranked
        XCTAssertEqual(optimalTimes.count, 3) // Only 3 times fall between 6 AM and 6 PM
        XCTAssertEqual(optimalTimes.first?.score, 100) // Highest score should be first
        XCTAssertEqual(optimalTimes.last?.score, 50) // Lowest score should be last
    }
    
    func testFilteringValidSurfingConditions() {
        let mockWeatherData = [
            WeatherData(app_temp: 21.0, clouds: 10, datetime: "2023-10-01:08", temp: 22.0, wind_spd: 12.0, weather: WeatherCondition(icon: "c01d", description: "Clear sky", code: 800)), // Valid
            WeatherData(app_temp: 19.0, clouds: 80, datetime: "2023-10-01:10", temp: 19.0, wind_spd: 25.0, weather: WeatherCondition(icon: "c04d", description: "Overcast", code: 803)), // Invalid (high wind speed)
            WeatherData(app_temp: 25.0, clouds: 5, datetime: "2023-10-01:14", temp: 25.0, wind_spd: 8.0, weather: WeatherCondition(icon: "c02d", description: "Partly cloudy", code: 801)) // Valid
        ]
        
        weatherAPIManager.weatherData = mockWeatherData
        let filteredTimes = weatherAPIManager.getOptimalSurfingTimes()
        
        XCTAssertEqual(filteredTimes.count, 2, "Only valid weather conditions should be included.")
    }

    func testRankingBySurfingScore() {
        let mockWeatherData = [
            WeatherData(app_temp: 20.0, clouds: 15, datetime: "2023-10-01:09", temp: 21.0, wind_spd: 10.0, weather: WeatherCondition(icon: "c01d", description: "Clear sky", code: 800)), // Score ~100
            WeatherData(app_temp: 22.0, clouds: 10, datetime: "2023-10-01:11", temp: 23.0, wind_spd: 9.0, weather: WeatherCondition(icon: "c02d", description: "Partly cloudy", code: 801)), // Score ~90
            WeatherData(app_temp: 19.0, clouds: 5, datetime: "2023-10-01:13", temp: 20.0, wind_spd: 12.0, weather: WeatherCondition(icon: "c01d", description: "Clear sky", code: 800)) // Score ~85
        ]

        weatherAPIManager.weatherData = mockWeatherData
        let rankedTimes = weatherAPIManager.getOptimalSurfingTimes()
        
        XCTAssertEqual(rankedTimes.count, 3, "All valid times should be included.")
        XCTAssertGreaterThan(rankedTimes.first!.score, rankedTimes.last!.score, "First element should have the highest score.")
    }

}
