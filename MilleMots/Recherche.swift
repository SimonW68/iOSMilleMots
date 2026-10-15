//
//  Recherche.swift
//  MilleMots
//
//  Created by Simon Wintz on 20/11/2025.
//

import Foundation
import SwiftUI

struct Recherche: View {
    @Binding var displayRecherche: Bool
    @Binding var odsAffiche: Ods9?
    @State var refOds: Ods9?
    @State var btnEnabled: Bool = false
    @State var saisie: String = VIDE
    @State private var drapeau = Drapeau.ok
    @FocusState private var searchFocus: Bool
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.white)
                .opacity(0.01)
                .edgesIgnoringSafeArea(.all)
                
            VStack {
                Spacer()
                HStack {
                    Button(LOUPE) {
                        actionSubmit()
                    }
                    .padding(.horizontal, 20)
                    .disabled(!btnEnabled)
                    TextField(VIDE, text:$saisie)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxLarge/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding()
                        .focused($searchFocus)
                        .foregroundColor(chooseColor(drapeau: drapeau))
                        .onChange(of: saisie) {
                            refOds = getOdsRef(context: viewContext, mot: saisie)
                            if refOds != nil {
                                btnEnabled = true
                                if refOds!.mot != nil {
                                    drapeau = .doublon
                                } else {
                                    drapeau = .ok
                                }
                            } else {
                                btnEnabled = false
                                drapeau = .inconnu
                            }
                        }
                        .onSubmit {
                            actionSubmit()
                        }
                    Spacer()
                    Button(CANCEL) {
                        displayRecherche.toggle()
                    }
                    .padding(.horizontal, 20)
                }
                .formatVue()
                Spacer()
                Spacer()
            }
        }
        .onAppear() {
            searchFocus = true
        }
        .onTapGesture {
            displayRecherche.toggle()
        }
    }
    private func actionSubmit() {
        if drapeau != .inconnu {
            odsAffiche = refOds
            hideKeyboard()
            displayRecherche.toggle()
        } else {
            searchFocus = true
        }
    }
}
