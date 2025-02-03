//
//  CitySelectionView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct CitySelectionView: View {
    @StateObject private var viewModel: CitySelectionVM
    init(weatherService: WeatherServiceProtocol = WeatherAPIService()) {
        // Initializing the viewModel with the injected weatherService
        _viewModel = StateObject(wrappedValue: CitySelectionVM(weatherService: weatherService))
    }
    @State private var selectedCountry: String = "Turkey" // Default country
    @State private var countryCode: String = "TR" // ISO Code
    @State private var isCountryExpanded = false
    @State private var isCityExpanded = false
    @State private var tempCountry: String = ""
    @State private var tempCity: String = ""
    @State private var selectedCountryItem = DropdownItemModel(id: "", text: "")
    @State private var selectedCityItem = DropdownItemModel(id: "", text: "")
    @StateObject private var weatherManager = WeatherAPIManager(weatherService: WeatherAPIService())
    @State private var isNavigatingToWeather = false
    @State private var weatherData: WeatherData?
    @State private var optimalSurfingTimes: [SurfingTime] = []
    
    @State private var citySearchText: String = "" // Search text for cities
    @State private var filteredCities: [DropdownItemModel] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                DropdownField(
                    title: "Please Select Country",
                    isExpanded: $isCountryExpanded,
                    chosenItem: $selectedCountryItem
                )
                .onTapGesture {
                    isCountryExpanded = true
                }
                .onChange(of: selectedCountryItem) { newValue in
                    viewModel.selectedCountry = newValue.text
                    selectedCityItem = DropdownItemModel(id: "", text: "")
                    citySearchText = "" // Reset city search when country changes
                    filteredCities = viewModel.cities // Reset filtered cities
                }
                DropdownField(
                    title: "Please Select City",
                    isExpanded: $isCityExpanded,
                    chosenItem: $selectedCityItem
                )
                .onTapGesture {
                    isCityExpanded = true
                }
              
                Spacer()
                Button {
                    Task {
                        await viewModel.fetchWeather(for: selectedCityItem.text, countryCode: selectedCountryItem.id ?? "")
                    }
                } label: {
                    Text("Check Weather")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .opacity(selectedCityItem.text.isEmpty ? 0.5 : 1)
                }
                .disabled(selectedCityItem.text.isEmpty)
                NavigationLink(
                    destination: WeatherConditionView(
                        weatherAPIManager: weatherManager,
                        city: selectedCityItem.text,
                        country: selectedCountryItem.text
                    ),
                    isActive: $viewModel.isNavigatingToWeather
                ) {
                    EmptyView()
                }
            }
            .padding(.top, 50)
        }
        .pickerModifier(options: $viewModel.countries, isExpanded: $isCountryExpanded, selectedItem: $selectedCountryItem)
        .pickerModifier(options: $viewModel.cities, isExpanded: $isCityExpanded, selectedItem: $selectedCityItem)
        .onAppear {
            viewModel.selectedCountry = selectedCountryItem.text
        }
    }
}
#Preview {
    CitySelectionView()
}
