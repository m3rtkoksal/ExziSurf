//
//  ContentView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showCitySelection = false // Initially false for navigation trigger
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Surf App!")
                    .font(.largeTitle)
                    .padding()
                
                Button {
                    showCitySelection = true // This will trigger the navigation
                } label: {
                    Text("Enter")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // NavigationLink to CitySelectionView, triggered when showCitySelection is true
                NavigationLink(destination: CitySelectionView(), isActive: $showCitySelection) {
                    EmptyView()
                }
            }
            .navigationTitle("Surf App")
        }
    }
}

#Preview {
    ContentView()
}
