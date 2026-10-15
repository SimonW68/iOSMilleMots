//
//  StoreAppli.swift
//  Karnage
//
//  Created by Simon Wintz on 05/09/2025.
//

import Foundation
import SwiftUI

struct StoreAppli: View {
    let appName: String
    let appId: String
    let pitch: String
    var body: some View {
        HStack {
            Image(appName.lowercased())
                .resizable()
                .frame(width: 40 , height:  40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text("\(appName), jeu pour iPhone et iPad")
                .font(.headline)
        }
        Text(pitch)
        Button(action: {
            let url = URL(string: "https://apps.apple.com/fr/app/\(self.appName)/id\(self.appId)")!
            UIApplication.shared.open(url)
        }) {
        Text("Télécharger \(appName)")
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.blue)
            .cornerRadius(15)
        }
        .frame(maxWidth:.infinity, alignment: .center)    }
}
