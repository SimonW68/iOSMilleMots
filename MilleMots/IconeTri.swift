//
//  IconeTri.swift
//  MilleMots
//
//  Created by Simon Wintz on 25/06/2024.
//

import Foundation
import SwiftUI

struct IconeTri : View {
    var ordreTri : OrdreTri
    var body : some View {
        HStack(spacing:0) {
            Image("btn_tri")
                .resizable(resizingMode: .stretch)
                .frame(width: 30, height: 30)
                .padding([.top, .bottom], 2)
                .padding([.leading], -15)
            ordreTri.image
                .resizable(resizingMode: .stretch)
                .frame(width: BTN_SIZE, height: BTN_SIZE)
                .padding(.leading, -5)
        }
        .padding(.trailing, [.alpha,.err].contains(ordreTri) ? -5 : 0)
    }
}
