//
//  PickerModifier.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct PickerModifier: ViewModifier {
    @Binding var options: [DropdownItemModel]
    @Binding var isExpanded: Bool
    @Binding var selectedItem: DropdownItemModel
    var buttonAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isExpanded)
            
            if isExpanded {
                BackgroundBlurView(style: .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
            }
            
            if isExpanded {
                VStack {
                    Spacer()
                    PickerView(options: $options,
                               selectedItem: $selectedItem,
                               isExpanded: $isExpanded)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .offset(y: 30)
                }
                .ignoresSafeArea()
            }
        }
    }
}

extension View {
    func pickerModifier(
        options: Binding<[DropdownItemModel]>,
        isExpanded: Binding<Bool>,
        selectedItem: Binding<DropdownItemModel>,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        modifier(PickerModifier(
            options: options,
            isExpanded: isExpanded,
            selectedItem: selectedItem,
            buttonAction: buttonAction
        ))
    }
}
