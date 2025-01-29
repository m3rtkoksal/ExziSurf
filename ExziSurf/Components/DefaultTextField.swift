//
//  DefaultTextField.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct DefaultTextField: View {
    @Binding var text: String
    var icon: String
    var iconAction: () -> Void
    var placeholder: String
    var fontColor: Color
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty, placeholder: {
                    Text(placeholder)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                })
                .foregroundColor(fontColor)
                .disableAutocorrection(true)
                .padding(.horizontal, 10)
            Spacer()
            Button(action: {
                iconAction()
            }) {
                HStack {
                    Image(icon)
                        .resizable()
                        .frame(width: 15, height:15)
                        .padding(.trailing)
                }
            }
            
        }
    }
}

struct DefaultTextField_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTextField(text: .constant("Default TextField"), icon:"camera", iconAction:{ }, placeholder: "Place Holder", fontColor: .black)
    }
}
