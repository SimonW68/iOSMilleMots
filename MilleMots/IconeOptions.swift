//
//  IconeOptions.swift
//  MilleMots
//
//  Created by Simon Wintz on 23/11/2025.
//

import Foundation
import SwiftUI

struct IconeOptions: View {
    @EnvironmentObject var com : Com
    var body: some View {
        HStack(spacing: -3) {
            Image("options")
                .resizable()
                .frame(width: BTN_SIZE, height: BTN_SIZE)
            VStack(spacing: 3) {
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .fill(com.optionEnCours == .motsProches ? .black : .transparent)
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .fill(com.optionEnCours == .anagrammes ? .black : .transparent)
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .fill(com.optionEnCours == .motPlusUn ? .black : .transparent)
            }
            .frame(width: BTN_SIZE, height: BTN_SIZE)
        }
    }
}
