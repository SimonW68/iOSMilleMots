//
//  InfoElimots.swift
//  MilleMots
//
//  Created by Simon Wintz on 16/12/2024.
//

import Foundation
import SwiftUI

struct InfoElimots: View {
    let info = String(localized: "Les définitions pour les mots nouveaux, proposées par MilleMots, proviennent du remarquable site de Sylvain Ravot : [elimots/ods.com](https://elimots.com/ods/)")
    
    var body: some View {

        ZStack {
            VStack{
                Image("dico")
                    .resizable()
                    .frame(width: 1.2 * BTN_SIZE, height: 1.2 * BTN_SIZE)
                Text(.init(info))
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(.blue)
            }
        }
    }
}
