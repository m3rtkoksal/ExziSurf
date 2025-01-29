//
//  CitySelectionVM.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

class CitySelectionVM: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var optimalSurfingTimes: [SurfingTime] = []
    @Published var isNavigatingToWeather: Bool = false

    private var weatherManager = WeatherAPIManager()
    
    @Published var countriesDict = [
        "Turkey": "TR",
        "United States": "US",
        "Germany": "DE",
        "France": "FR",
        "United Kingdom": "GB",
        "Canada": "CA",
        "Spain": "ES",
        "Portugal": "PT",
        "Italy": "IT",
        "Australia": "AU",
        "Brazil": "BR",
        "South Africa": "ZA",
        "Greece": "GR",
        "New Zealand": "NZ",
        "Japan": "JP"
    ]
    
    @Published var citiesDict: [String: [String]] = [
        "Turkey": ["Alaçatı", "Gökçeada", "Akyaka", "Datça", "Bodrum"],
        "United States": ["Maui (Hawaii)", "Hatteras (North Carolina)", "Gorge (Oregon)", "San Francisco Bay (California)", "Florida Keys"],
        "Germany": ["Fehmarn", "Sylt", "Rügen", "Westerland"],
        "France": ["Leucate", "Gruissan", "Brest", "La Torche", "Hyeres"],
        "United Kingdom": ["Hayling Island", "Rhosneigr", "West Wittering", "Poole Harbour", "Cornwall"],
        "Canada": ["Vancouver Island", "Acadian Peninsula", "Lake Ontario", "Squamish", "Nova Scotia"],
        "Spain": ["Tarifa", "Fuerteventura (Canary Islands)", "Lanzarote", "Gran Canaria", "Costa Brava"],
        "Portugal": ["Guincho", "Porto", "Madeira", "Viana do Castelo"],
        "Italy": ["Lake Garda", "Sardinia", "Sicily", "Torbole", "Elba Island"],
        "Australia": ["Margaret River", "Geraldton", "Gold Coast", "Perth", "Sydney"],
        "Brazil": ["Jericoacoara", "Icaraizinho", "Fortaleza", "Florianópolis", "Cumbuco"],
        "South Africa": ["Cape Town (Big Bay)", "Langebaan", "Jeffreys Bay", "Durban"],
        "Greece": ["Paros", "Rhodes (Prasonisi)", "Naxos", "Kos", "Karpathos"],
        "New Zealand": ["Wellington", "Auckland", "Christchurch", "Taranaki"],
        "Japan": ["Okinawa", "Miyako Island", "Shonan Beach", "Chiba"]
    ]
    
    @Published var countries: [DropdownItemModel] = []
    @Published var cities: [DropdownItemModel] = []
    @Published var selectedCountry: String? {
        didSet {
            updateCities()
        }
    }
    
    init() {
        // Convert countriesDict to DropdownItemModel array
        self.countries = countriesDict.map { (key, value) in
            DropdownItemModel(id: value, text: key)
        }
        
        // Default to an empty list of cities until a country is selected
        self.cities = []
    }
    
    private func updateCities() {
        guard let country = selectedCountry, let countryCities = citiesDict[country] else {
            self.cities = []
            return
        }
        
        self.cities = countryCities.map { city in
            DropdownItemModel(id: city, text: city)
        }
    }
    
    func fetchWeather(for city: String, countryCode: String) async {
        await weatherManager.fetchWeather(for: city, countryCode: countryCode)
        if let firstWeatherData = weatherManager.weatherData.first {
            DispatchQueue.main.async {
                self.weatherData = firstWeatherData
                self.optimalSurfingTimes = self.weatherManager.optimalSurfingTimes
                self.isNavigatingToWeather = true
            }
        }
    }
}
