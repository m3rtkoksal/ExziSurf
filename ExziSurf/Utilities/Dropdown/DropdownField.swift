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
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .frame(width: UIScreen.main.bounds.width, height: 1)
                        .background(Color.black)

                    Text(chosenItem.text.isEmpty ? title : chosenItem.text)
                        .font(.system(size: 14))
                        .foregroundColor(chosenItem.text.isEmpty ? .gray : .black)
                        .padding(.leading, 20)
                        .frame(height: 26)
                        .accessibilityIdentifier("dropdownItem-\(chosenItem.text)")
                    Divider()
                        .frame(width: UIScreen.main.bounds.width, height: 1)
                        .background(Color.black)
                }
                .frame(height: 46)
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
