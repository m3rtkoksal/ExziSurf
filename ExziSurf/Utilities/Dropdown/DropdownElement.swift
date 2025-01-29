//
//  DropdownElement.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct DropdownElement: View {
    var item: DropdownItemModel
    var isChosen: Bool
    
    var body: some View {
        HStack {
            Text(item.text)
                .font(.system(size: 12))
                .foregroundColor(isChosen ? .black : .gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8) // Optionally add rounded corners for better UI
    }
}

struct DropdownElement_Previews: PreviewProvider {
    static var previews: some View {
        DropdownElement(item: DropdownItemModel(icon: "", text: "Lorem Ipsum"), isChosen: false)
    }
}
