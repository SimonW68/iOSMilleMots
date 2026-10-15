//
//  ReglageFiltre.swift
//  MilleMots
//
//  Created by Simon Wintz on 12/11/2025.
//

import Foundation
import SwiftUI

struct OutilFiltre: View {
    @Binding var displaySelf: Bool
    @State var elemEnCours: ElementFiltre?
    @State var clavier: [[String]] = []
    @State var loadingData: Bool = false
    @EnvironmentObject var com : Com
    
    @State var hideToolWorkItem: DispatchWorkItem?
    
    var body: some View {
        VStack {
            HStack {
                CartLong(lMin: $com.lMin, lMax: $com.lMax, hideTool: hideToolAfterDelay)
                    .disabled(com.displayKbd)
                Circle()
                    .stroke(.black, lineWidth: 2)
                    .fill(Color("fondbleu"))
                    .frame(width:SELECTOR_SIZE, height:SELECTOR_SIZE)
                    .opacity(com.monomesOnly ? 1.0 : 0.0)
                    .overlay(
                        Button("M") {
                            if !com.anagramme {
                                com.monomesOnly.toggle()
                            } else {
                                com.message = "Désactivez l'option de jeu \"anagramme\" pour pouvoir filtrer les monômes"
                            }
                            com.applyFilter()
                            hideToolAfterDelay(TEMPS_HIDE_FILTRE_TOOL)
                        }
                        .padding(.top, 10)
                        .font(.custom("Savoye LET", size: 24))
                        .dynamicTypeSize(.xLarge)
                        .fontWeight(.bold)
                        .disabled(com.displayKbd)
                    )
            }
            VStack(spacing: 6) {
                HStack {
                    Spacer()
                    Text("Composez votre filtre")
                        .fontWeight(.bold)
                    Spacer()
                    Button() {
                        com.clearQuery()
                    } label:{
                        Image("trash")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                    }
                    .opacity(com.displayKbd ? 0 : 1)
                    Spacer()
                }
                HStack {
                    Text("Préfixe")
                        .frame(width: 120, alignment: .leading)
                    Text(":")
                    LigneFiltre(com.strPref)
                    Spacer()
                }
                .fontWeight(elemEnCours == .prefix ? .bold : .regular)
                .onTapGesture {
                    select(elem: .prefix)
                }
                HStack {
                    Text("Contenu")
                        .frame(width: 120, alignment: .leading)
                    Text(":")
                    LigneFiltre(com.strCont)
                    Spacer()
                }
                .fontWeight(elemEnCours == .content ? .bold : .regular)
                .onTapGesture {
                    select(elem: .content)
                }
                HStack {
                    Text("Suffixe")
                        .frame(width: 120, alignment: .leading)
                    Text(":")
                    LigneFiltre(com.strSuff)
                    Spacer()
                }
                .fontWeight(elemEnCours == .suffix ? .bold : .regular)
                .onTapGesture {
                    select(elem: .suffix)
                }
                HStack {
                    Text("Exclusions")
                        .frame(width: 120, alignment: .leading)
                    Text(":")
                    LigneFiltre(com.strExcl)
                    Spacer()
                }
                .fontWeight(elemEnCours == .exclut ? .bold : .regular)
                .onTapGesture {
                    select(elem: .exclut)
                }
                if com.displayKbd {
                    VStack (spacing: ENTRE_TOUCHES) {
                        ForEach(0..<clavier.endIndex, id: \.self) { indexLigne in
                            HStack (spacing: ENTRE_TOUCHES) {
                                ForEach(0..<clavier[indexLigne].endIndex, id: \.self) {  indexTouche in
                                    let lettre = clavier[indexLigne][indexTouche]
                                    Text(lettre)
                                        .formatTouche(toucheSize: 0.8 * com.tuileSize, isIndice: GENERIQUES.contains(lettre))
                                        .onTapGesture {
                                            if lettre == RETURN {
                                                select(elem: elemEnCours!)
                                            } else {
                                                switch elemEnCours! {
                                                case .prefix: com.strPref = saisie(str: com.strPref, touche: lettre)
                                                case .content: com.strCont = saisie(str: com.strCont, touche: lettre)
                                                case .suffix: com.strSuff = saisie(str: com.strSuff, touche: lettre)
                                                case .exclut: com.strExcl = saisie(str: com.strExcl, touche: lettre)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .dynamicTypeSize(.xxxLarge)
            .onAppear() {
                hideToolAfterDelay()
            }
        }
        .overlay(loadingData ? LoadingView() : nil )
    }
    private func hideToolAfterDelay(_ temps: DispatchTimeInterval = TEMPS_HIDE_FILTRE_TOOL) {
        cancelHideTool()
        hideToolWorkItem = DispatchWorkItem { [self] in
            displaySelf = false
            loadingData = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + temps, execute: hideToolWorkItem!)
    }
    private func cancelHideTool() {
        hideToolWorkItem?.cancel()
    }
    private func hideKeyboard() {
        com.displayKbd = false
        hideToolAfterDelay()
    }
    private func displayKeyboard(elem: ElementFiltre) {
        cancelHideTool()
        switch elem {
        case .prefix, .suffix :
            clavier = CLAVIER_COMPLET.dropFirst().map { $0.filter { $0 != ET && $0 != Q_SANS_U } }
        case .exclut :
            clavier = CLAVIER_COMPLET.map { $0.filter { ![OU, "2", "3", "4", Q_SANS_U].contains($0)} }
        default :
            clavier = CLAVIER_COMPLET.map { $0.filter { $0 != NON_VELOS } }
        }
        com.displayKbd = true
    }

    private func select(elem: ElementFiltre) {
        if elemEnCours == nil {
            elemEnCours = elem
            displayKeyboard(elem: elem)
        } else {
            let strEnCours = switch(elemEnCours!) {
                case .prefix: com.strPref
                case .content: com.strCont
                case .suffix: com.strSuff
                case .exclut: com.strExcl
            }
            if strEnCours.filtreValide {
                if elem == elemEnCours {
                    elemEnCours = nil
                    hideKeyboard()
                    com.applyFilter()
                } else {
                    displayKeyboard(elem: elem)
                    elemEnCours = elem
                }
            }
        }
    }
    
    private func saisie(str: String, touche: String) -> String {
        let long = str.count
        let sep = str.contains("o") ? "o" : "e"
        let strList = str.components(separatedBy: sep)
        let suf = strList.last ?? VIDE
        let pref = str.delSuffix(suf)
        let codeTouche = CODAGE[touche] ?? touche

        return switch codeTouche {
        case CLEAR :
            VIDE
        case _ where GENERIQUES.contains(codeTouche) : // ne peuvent pas être collé à autre chose qu'un multiplicateur, ni répétés
            if long == 0 || suf == VIDE && !pref.contains(codeTouche) || LIST_234.contains(suf) {
                    str + codeTouche
            } else {
                str
            }
        case _ where LIST_234.contains(codeTouche) : // ne peut pas être collé à autre chose
            if long == 0 || suf == sep {
                str + codeTouche
            } else {
                str
            }
        case "o" :
            if suf == VIDE || LIST_234.contains(suf) || pref.contains("e") || strList.count(where: {$0 == suf}) > 1 { // pas deux OU d'affilée, et pas de OU si déjà un ET, pas deux fois le même élément
                str
            } else {
                str + "o"
            }
        case "e" :
            if suf == VIDE || LIST_234.contains(suf) || pref.contains("o") || strList.count(where: {$0 == suf}) > 1  { // pas deux ET d'affilée, et pas de ET si déjà un OU, pas deux fois le même élément
                str
            } else {
                str + "e"
            }
        case BACKSPACE :
            if long == 0 {
                VIDE
            } else {
                String(str.dropLast(1))
            }
        default:
            if GENERIQUES.contains(suf) {// pas possible coller une lettre à un générique
                str
            } else {
                str + codeTouche
            }
        }
    }
}
