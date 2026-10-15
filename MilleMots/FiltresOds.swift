//
//  OdsFiltres.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/02/2025.
//

import Foundation
import SwiftUI
import CoreData

struct FiltresOds : View {
    var ods: FetchedResults<Ods9>
    @Binding var motAffiche: Mot?
    var lMax: Int
    @EnvironmentObject var jeu: JeuSet
    init(
        ods: FetchedResults<Ods9>,
        motAffiche: Binding<Mot?>,
        lMax: Int
    ) {
        self.ods = ods
        self._motAffiche = motAffiche
        self.lMax = lMax
    }
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView { // listes de mots
            NavigationStack {
                LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .leading) {
                    ForEach(ods, id:\.self) { ods in
                        NavigationLink(destination: NouveauMot(mots: ods.graphie ?? "")) {
                            Text(ods.graphie ?? "")
                                .dynamicTypeSize(chooseDynamicSize(lMax: lMax))
                                .bold()
                                .foregroundColor(Color.green)
                        }
                    }
                    .frame(maxWidth: 500)
                }
            }
        }
    }
}
