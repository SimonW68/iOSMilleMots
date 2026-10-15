//
//  ChoixOption.swift
//  MilleMots
//
//  Created by Simon Wintz on 24/11/2025.
//

import Foundation
import SwiftUI


struct ChoixOption: View {
    @Binding var option1: Bool
    @Binding var option2: Bool
    @Binding var option3: Bool
    let label1: String
    let label2: String
    let label3: String

    var body: some View {
        VStack {
            Toggle(label1, isOn: $option1)
                .onChange(of: option1) {
                    if option1 {
                        option2 = false
                        option3 = false
                    }
                }
            Toggle(label2, isOn: $option2)
                .onChange(of: option2) {
                    if option2 {
                        option1 = false
                        option3 = false
                    }
                }
            Toggle(label3, isOn: $option3)
                .onChange(of: option3) {
                    if option3 {
                        option1 = false
                        option2 = false
                    }
                }
        }
    }
}
