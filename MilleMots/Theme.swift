//
//  Theme.swift
//  MilleMots
//
//  Created by Simon Wintz on 26/11/2025.
//

import Foundation
import SwiftUI

struct Theme: View {
    @EnvironmentObject var com : Com
    var body: some View {
        VStack {
            Text("Mode : \(com.optionEnCours.rawValue)")
            Text("Base : \(com.descriptionFiltre().first! + com.descriptionFiltre()[1] + com.descriptionFiltre()[2])")
        }
        .padding()
        .dynamicTypeSize(.xLarge)
        .formatVue("fondbleu")
    }
}
