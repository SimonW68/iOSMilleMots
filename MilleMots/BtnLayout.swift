//
//  BtnLayout.swift
//  MilleMots
//
//  Created by Simon Wintz on 13/11/2025.
//

import Foundation
import SwiftUI

struct BtnLayout: View {
    @Binding var displayRecherche: Bool
    @Binding var displayOptions: Bool
    @EnvironmentObject var com : Com

    var body: some View {
        ZStack {
            HStack {
                NavigationLink(destination: Edit(motRecherche: VIDE)){
                    Image("dico")
                        .btnStyle()
                }
                Spacer()
                NavigationLink(value: DataObject.init(name: "help")) {
                    Image("settings")
                        .resizable(resizingMode: .stretch)
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
                Spacer()
                NavigationLink(value: DataObject.init(name: "refill")) {
                    Image("essence")
                        .resizable(resizingMode: .stretch)
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
                Spacer()
                Button() {
                    displayOptions.toggle()
                } label: {
                    IconeOptions()
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
                Spacer()
                Button() {
                    com.motsAtrouver = com.preMotsAtrouver
                    com.isInterro = true
                    displayOptions = false
                    com.path.append(DataObject(name: "interrogation"))
                } label: {
                    Image("exercice")
                        .resizable(resizingMode: .stretch)
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
                .disabled(!com.pret)
                .opacity(com.pret ? 1.0 : 0.3)
            }
            .padding()
            .formatVue()
        }
        .padding(.bottom, DECALAGE_BORDURE)
    }
}
