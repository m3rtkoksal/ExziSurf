//
//  CitySelectionView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct CitySelectionView: View {
    @StateObject private var viewModel = CitySelectionVM()
    @State private var selectedCountry: String = "Turkey" // Default country
    @State private var countryCode: String = "TR" // ISO Code
    @State private var isCountryExpanded = false
    @State private var isCityExpanded = false
    @State private var tempCountry: String = ""
    @State private var tempCity: String = ""
    @State private var selectedCountryItem = DropdownItemModel(id: "", text: "")
    @State private var selectedCityItem = DropdownItemModel(id: "", text: "")
    @StateObject private var weatherManager = WeatherAPIManager(urlSession: URLSession.shared)
    @State private var isNavigatingToWeather = false
    @State private var weatherData: WeatherData?
    @State private var optimalSurfingTimes: [SurfingTime] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                DropdownField(
                    title: "Please Select Country",
                    isExpanded: $isCountryExpanded,
                    chosenItem: $selectedCountryItem
                )
                .onTapGesture {
                    isCountryExpanded = true
                }
                .onChange(of: selectedCountryItem) { oldValue, newValue in
                    if oldValue.id != newValue.id { // Prevent redundant updates
                        viewModel.selectedCountry = newValue.text
                    }
                }
                DropdownField(
                    title: "Please Select City",
                    isExpanded: $isCityExpanded,
                    chosenItem: $selectedCityItem
                )
                .onTapGesture {
                    isCityExpanded = true
                }
                .onChange(of: selectedCityItem) { oldValue, newValue in
                    if newValue.text.isEmpty {
                        selectedCityItem = viewModel.cities.first ?? DropdownItemModel(id: "", text: "")
                    }
                }
                Spacer()
                Button {
                    Task {
                        await viewModel.fetchWeather(for: selectedCityItem.text, countryCode: selectedCountryItem.id ?? "")
                    }
                } label: {
                    Text("Check Weather")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(selectedCityItem.text.isEmpty ? 0.5 : 1)
                }
                .disabled(selectedCityItem.text.isEmpty)
                NavigationLink(destination: WeatherConditionView(weather: viewModel.weatherData, optimalSurfingTimes: viewModel.optimalSurfingTimes), isActive: $viewModel.isNavigatingToWeather) {
                    EmptyView()
                }
            }
            .padding(.top, 50)
        }
        .pickerModifier(options: $viewModel.countries, isExpanded: $isCountryExpanded, selectedItem: $selectedCountryItem)
        .pickerModifier(options: $viewModel.cities, isExpanded: $isCityExpanded, selectedItem: $selectedCityItem)
        .onAppear {
            viewModel.selectedCountry = selectedCountryItem.text // Ensure initial cities load
            if let firstCity = viewModel.cities.first {
                selectedCityItem = firstCity
            }
        }
    }
}
#Preview {
    CitySelectionView()
}
