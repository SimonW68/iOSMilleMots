//
//  RadioButton.swift
//  MilleMots
//
//  Created by Simon Wintz on 31/12/2025.
//

import Foundation
import SwiftUI

struct RadioButton: View {
    let option: OptionJeu
    @Binding var enCours: OptionJeu
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.white.opacity(0.01))
                .stroke(
                    Color(Color.black),
                    lineWidth: 1
                )
                .onTapGesture {
                    enCours = option
                }
                .frame(width: BTN_SIZE, height: BTN_SIZE)
                .overlay(enCours == option ?
                         Circle()
                            .fill(Color.black)
                            .frame(width: BTN_SIZE / 2, height: BTN_SIZE / 2) : nil)
            Spacer()
            Text(option.rawValue)
        }
        .padding()
    }
    
}
