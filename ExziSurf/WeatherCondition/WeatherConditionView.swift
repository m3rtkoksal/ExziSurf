//
//  WeatherConditionView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct WeatherConditionView: View {
    @ObservedObject var weatherAPIManager: WeatherAPIManager
    var optimalSurfingTimes: [SurfingTime]?
    var city: String
    var country: String

    @State private var isLoading = true  // Add a loading state
    @State private var errorMessage: String? = nil // Error state

    var body: some View {
        VStack {
            if isLoading {
                // Show a loading spinner while the data is being fetched
                ProgressView("Loading weather data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = errorMessage {
                // If there was an error, display the error message
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Once data is fetched, show the weather info
                if let weather = weatherAPIManager.weatherData.first {
                    Text("🌡 Temperature: \(weather.temp, specifier: "%.1f")°C")
                        .font(.largeTitle)

                    Text("💨 Wind Speed: \(weather.wind_spd, specifier: "%.1f") m/s")
                        .font(.title2)

                    let surfingScore = weatherAPIManager.calculateSurfingScore(weather: weather)
                    Text("🏄 Surfing Score: \(surfingScore, specifier: "%.1f")")
                        .font(.title2)
                        .foregroundColor(surfingScore > 70 ? .green : .red)

                    Text("☁️ Condition: \(weather.weather.description)")
                        .font(.title3)
                } else {
                    Text("No weather data available.")
                        .foregroundColor(.gray)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        if !weatherAPIManager.optimalSurfingTimes.isEmpty {
                            ForEach(weatherAPIManager.optimalSurfingTimes) { surfingTime in
                                OptimalSurfingTimeCell(surfingTime: surfingTime)
                            }
                        } else {
                            Text("No optimal surfing times available.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .navigationTitle("\(city), \(country)")
        .onAppear {
            fetchWeatherData()
        }
    }

    private func fetchWeatherData() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                // Trigger the API call to fetch the weather data
                try await weatherAPIManager.fetchWeather(for: city, countryCode: country)
                isLoading = false
            } catch {
                // If there is an error, handle it here
                isLoading = false
                errorMessage = "Failed to load weather data. Please try again."
            }
        }
    }
}
