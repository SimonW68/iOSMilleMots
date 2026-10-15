//
//  StatsMot.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/05/2024.
//

import Foundation
import SwiftUI

struct StatsMot : View {
    var motAffiche : Mot
    
    var body: some View {
        HStack {
            Image("cible")
                .btnStyle(SMALL_BTN_SIZE)
            Text("\(motAffiche.nEssai)")
            Spacer()
            Circle()
                .stroke(.black, lineWidth: 1)
                .fill(.red)
                .frame(width: 8, height: 8)
            Text("\(motAffiche.nEchec)")
            Spacer()
            Circle()
                .stroke(.black, lineWidth: 1)
                .fill(Color("vert"))
                .frame(width: 8, height: 8)
            Text("\(motAffiche.sqSucces)")
            Spacer()
            Text("\(motAffiche.nSession)")
                .frame(width:20.0)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
        }
        .font(.caption)
    }
}
