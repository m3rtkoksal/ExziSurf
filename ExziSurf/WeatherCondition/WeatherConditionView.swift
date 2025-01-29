//
//  WeatherConditionView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct WeatherConditionView: View {
    var weather: WeatherData?
    var optimalSurfingTimes: [SurfingTime]?
    
    var body: some View {
        VStack {
            if let weather = weather {
                // Temperature
                Text("🌡 Temperature: \(weather.temp, specifier: "%.1f")°C")
                    .font(.largeTitle)
                
                // Wind Speed
                Text("💨 Wind Speed: \(weather.wind_spd, specifier: "%.1f") m/s")
                    .font(.title2)
                
                // Surfing Score
                let surfingScore = WeatherAPIManager(urlSession: URLSession.shared).calculateSurfingScore(weather: weather)
                Text("🏄 Surfing Score: \(surfingScore, specifier: "%.1f")")
                    .font(.title2)
                    .foregroundColor(surfingScore > 70 ? .green : .red)
                
                // Condition
                Text("☁️ Condition: \(weather.weather.description)")
                    .font(.title3)
            } else {
                Text("No weather data available.")
                    .foregroundColor(.gray)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    if let optimalSurfingTimes = optimalSurfingTimes {
                        ForEach(optimalSurfingTimes) { surfingTime in
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
        .padding()
    }
}
