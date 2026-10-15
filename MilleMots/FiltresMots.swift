//
//  FiltresMots.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/02/2025.
//

import Foundation
import SwiftUI
import CoreData

struct FiltresMots : View {
    var mots: FetchedResults<Mot>
    @Binding var motAffiche: Mot?
    var lMax: Int
    @EnvironmentObject var jeu: JeuSet
    
    init(
        mots: FetchedResults<Mot>,
        motAffiche: Binding<Mot?>,
        lMax: Int
    ) {
        self.mots = mots
        self._motAffiche = motAffiche
        self.lMax = lMax
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView { // listes de mots
            LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .leading) {
                ForEach(mots, id:\.self) { mot in
                    let font =
                        if mot.baseActive { FONT_ACTIF }
                        else if mot.motMort { FONT_ACQUIS }
                        else { FONT_INACTIF }
                    Text(mot.refOds!.graphie ?? "")
                        .dynamicTypeSize(chooseDynamicSize(lMax: lMax))
                        .font(font)
                        .onTapGesture {
                            motAffiche = mot
                        }
                }
                .frame(maxWidth: 500)
            }
        }
    }
}
