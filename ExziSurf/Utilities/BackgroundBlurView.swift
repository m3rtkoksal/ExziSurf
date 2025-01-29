//
//  BackgroundBlurView.swift
//  ExziSurf
//
//  Created by Mert Köksal on 29.01.2025.
//

import SwiftUI

struct BackgroundBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let effectViewAlpha = 0.60
    
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.alpha = effectViewAlpha
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

