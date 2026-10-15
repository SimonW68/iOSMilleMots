//
//  DataPolicy.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/06/2024.
//

import Foundation
import SwiftUI

struct DataPolicy: View {
    let donnesPerso = String(localized: "Données personnelles : cette application ne collecte aucune donnée et ne partage aucune donnée avec des tiers [en savoir plus](https://sites.google.com/view/simonwintz/accueil/fr)")
    let pratiqueMillemots = String(localized: "La pratique de MilleMots comporte des risques : isolement, addiciton. Trouvez de l'aide sur : [joueurs-info-service.fr](https://www.joueurs-info-service.fr/)")
    
    var body: some View {

        ZStack {
            VStack{
                Text("Confidentialité de l'application")
                    .fontWeight(.bold)
                    .dynamicTypeSize(.xxLarge)
                    .padding(.vertical, 20)
                Text(.init(donnesPerso))
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(.blue)
                Text(.init(pratiqueMillemots))
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(.blue)
            }
        }
    }
}
