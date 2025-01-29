//
//  PickerView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct PickerView: View {
    @Binding var options: [DropdownItemModel]
    @Binding var selectedItem: DropdownItemModel
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                VStack(spacing: 20) {
                    ScrollView(showsIndicators: false) {
                        ForEach(options, id: \.self) { item in
                            Button(action: {
                                withAnimation {
                                    selectedItem = item
                                    isExpanded = false
                                }
                            }) {
                                HStack {
                                    Text(item.text)
                                        .font(.system(size: 17))
                                        .foregroundColor(.black)
                                }
                                .frame(height: 40)
                                .padding(.horizontal, 20)
                                .background(
                                    selectedItem == item ? Color.purple.opacity(0.3) : Color.clear
                                )
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxHeight: 300)
                .transition(.opacity)
                .animation(.easeInOut, value: isExpanded)
                .padding(.bottom, 25)
            }
        }
        .padding()
        .background(Color.white)
    }
}
