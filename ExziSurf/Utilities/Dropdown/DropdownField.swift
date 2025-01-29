//
//  DropdownField.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct DropdownField: View {
    var title: String
    @Binding var isExpanded: Bool
    @Binding var chosenItem: DropdownItemModel
    var isHiddenChangeText: Bool = false
    
    var body: some View {
        HStack {
            Button {
                isExpanded.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.indigo, lineWidth: 1)
                        .overlay(
                            VStack(alignment: .leading, spacing: 0) {
                                Text(chosenItem.text.isEmpty ? title : chosenItem.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(chosenItem.text.isEmpty ? .gray : .black)
                                    .accessibilityIdentifier("dropdownItem-\(chosenItem.text)")
                            }
                        )
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
            .background(Color.white)
        }
    }
}

struct DGDropdownField_Previews: PreviewProvider {
    static var previews: some View {
        DropdownField(
            title: "Title",
            isExpanded: .constant(false),
            chosenItem: .constant(DropdownItemModel(icon: "", text: ""))
        )
    }
}
