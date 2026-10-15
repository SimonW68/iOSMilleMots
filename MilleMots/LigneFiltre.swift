//
//  LigneFiltre.swift
//  MilleMots
//
//  Created by Simon Wintz on 18/11/2025.
//

import Foundation
import SwiftUI

struct LigneFiltre: View {
    var ligne: [Character]
    @EnvironmentObject var com : Com
    
    init(_ ligne: String) {
        self.ligne = Array(ligne)
    }
    
    var body: some View {
        ScrollViewReader { scroll in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    ForEach(ligne.indices, id: \.self) { index in
                        let char = String(ligne[index])
                        let lettre = DECODAGE[char] ?? char
                        if NON_FORMATTES.contains(char) {
                            Text(String(DECODAGE[char] ?? char ))
                                .font(.caption)
                        } else {
                            Text(lettre)
                                .formatLettre(lettreSize:0.5 * com.tuileSize, isIndice: GENERIQUES.contains(lettre))
                        }
                    }
                }
                .id("myHStackId")
                .onChange(of: ligne) {
                    withAnimation {
                        scroll.scrollTo("myHStackId", anchor: .trailing)
                    }
                }
            }
        }
    }
}
