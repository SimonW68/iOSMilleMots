//
//  CheckBox.swift
//  MilleMots
//
//  Created by Simon Wintz on 07/05/2024.
//

import Foundation
import SwiftUI

struct CheckBox : View {
    @Binding var isChecked : Bool
    
    var body : some View {
        Button {
            isChecked.toggle()
        } label: {
            Image(isChecked ? "checked" : "unchecked")
                .resizable(resizingMode: .stretch)
                .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
        }
    }
}
