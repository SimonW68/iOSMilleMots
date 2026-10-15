//
//  InfoBase.swift
//  MilleMots
//
//  Created by Simon Wintz on 04/04/2024.
//

import Foundation
import SwiftUI

struct InfoBase : View {
    var isGreen : Bool
    @State var txErr : Float = .zero
    @EnvironmentObject var com : Com
    
    init(isGreen: Bool = false) {
        self.isGreen = isGreen
    }
    
    var body: some View {
        HStack {
            Text("Σ \(com.totalBase)")
                .dynamicTypeSize(.xSmall)
            Spacer()
            Text("Σ \(isGreen ? com.totalOds : com.totalFiltre)")
                .foregroundColor(isGreen ? Color("vert") : .black)
                .dynamicTypeSize(.xSmall)
                .fontWeight(.bold)
            Spacer()
            Image("cible")
                .resizable(resizingMode: .stretch)
                .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
            Text("\(com.totalCoups)")
                .dynamicTypeSize(.xSmall)
            Spacer()
            Circle()
                .stroke(.black, lineWidth: 1)
                .fill(Color("vert"))
                .frame(width: 8, height: 8)
            
            Text(com.tauxSucces, format: .percent.rounded(increment: 1.0))
                .dynamicTypeSize(.xSmall)
        }
    }
}
