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
                Image(systemName: "surfboard.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.indigo, .white)
                    .frame(width: 150)
                    
                Text("Welcome to the Surf App!")
                    .font(.largeTitle)
                    .padding()
                
                Button {
                    showCitySelection = true // This will trigger the navigation
                } label: {
                    Text("Enter")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding(.horizontal, 50)
                        .background(Color.indigo)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                // NavigationLink to CitySelectionView, triggered when showCitySelection is true
                NavigationLink(destination: CitySelectionView(), isActive: $showCitySelection) {
                    EmptyView()
                }
            }
            .navigationTitle("🤙")
        }
    }
}

#Preview {
    ContentView()
}
