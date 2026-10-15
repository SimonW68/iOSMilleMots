//
//  store.swift
//  Carnaj
//
//  Created by Simon Wintz on 12/05/2025.
//

import Foundation
import SwiftUI

public struct Store : View {
    @EnvironmentObject var com : Com
    @Environment(\.dismiss) var dismiss
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image("appicon")
                            .resizable()
                            .frame(width: 40 , height:  40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Vous aimez MilleMots ?")
                            .font(.headline)
                    }
                    Button(action: {
                        let url = URL(string: "https://apps.apple.com/app/\(MILLEMOTS_NOM)/\(MILLEMOTS_ID)?action=write-review")!
                        UIApplication.shared.open(url)
                        
                    }) {
                        Text("Donner votre avis")
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                    }
                    .frame(maxWidth:.infinity, alignment: .center)
                    Spacer(minLength: 30)
                    StoreAppli(appName: CARNAJ_NOM, appId: CARNAJ_ID, pitch: CARNAJ_PITCH)
                    Spacer(minLength: 30)
                    StoreAppli(appName: KARNAGE_NOM, appId: KARNAGE_ID, pitch: KARNAGE_PITCH)
                    Spacer(minLength: 30)
                    if #available(iOS 17.0, *) {
                        StoreAppli(appName: MMLITE_NOM, appId: MMLITE_ID, pitch: MMLITE_PITCH)
                    }
                    Spacer(minLength: 40)
                    Button(action: {
                        self.dismiss()
                    }) {
                        Image("quitter")
                            .resizable()
                            .frame(width: 30 , height:  30)
                    }
                    .frame(maxWidth:.infinity, alignment: .center)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color("fondClair"))
    }
}
