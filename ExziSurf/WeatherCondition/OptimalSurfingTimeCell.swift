//
//  OptimalSurfingTimeCell.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct OptimalSurfingTimeCell: View {
    let surfingTime: SurfingTime
    
    var body: some View {
        HStack {
            Text("Time: \(surfingTime.datetime)")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("Surfing Score: \(surfingTime.score, specifier: "%.1f")")
                .font(.subheadline)
                .foregroundColor(surfingTime.score > 70 ? .green : .red)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
