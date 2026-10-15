//
//  Interro.swift
//  MilleMots
//
//  Created by Simon Wintz on 15/11/2025.
//

import Foundation
import SwiftUI
import CoreData

struct Interrogation: View {
    @State var motAffiche: Mot?
    @State var accMotAffiche: Accessoires?
    @State var accNext: Accessoires?
    @State var resultat = Resultat.ok
    @State var isUserPresent : Bool = true
    @EnvironmentObject var com : Com
    @AppStorage(USER_SEQ_SUCC) var seqSucc : Int = DEFAULT_SEQ_SUCC
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Mot.entity(), sortDescriptors: [])
    private var mots: FetchedResults<Mot>

    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                if motAffiche != nil {
                    DetailsMot(mot: motAffiche, acc: accMotAffiche)
                        .overlay(RoundedRectangle(cornerRadius:10).stroke(resultat.color, lineWidth: resultat.ep))
                Spacer()
                    .frame(height: 8)
                }
                ZStack (alignment: .topLeading) {
                    if com.phase != .final { // phase jeu
                      VStack {
                            JeuView(
                                motAffiche: $motAffiche,
                                isUserPresent: $isUserPresent,
                            )
                            .onChange(of: com.phase, initial: true) {
                                if com.phase == .ordi {
                                    if com.success {
                                        updateSucces(mot: com.motAtrouver!.mot!)
                                    } else if isUserPresent {
                                        com.addCorr(mot: com.motAtrouver!)
                                        updateFail(mot: com.motAtrouver!.mot!)
                                    } else {
                                        self.dismiss()
                                    }
                                    if com.nextMot() {
                                        getAcc(mot: com.motAtrouver!.mot!)
                                    } else {
                                        com.showPlusUn = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + DELAI_SORTIE) {
                                            resultat = .ok
                                            motAffiche = nil
                                            accMotAffiche = nil
                                            com.phase = .final
                                        }
                                    }
                                }
                            }
                            Spacer().frame(height: 8)
                            HStack {
                                Button() {
                                    com.isInterro = false
                                    self.dismiss()
                                } label:{
                                    Image("cancel")
                                        .btnStyle(SMALL_BTN_SIZE)
                                }
                                .padding(DECALAGE_BORDURE)
                                ProgressView(value: com.progressInterro)
                                    .padding(DECALAGE_BORDURE)
                                Button() {
                                    com.pause(!com.isPause)
                                } label:{
                                    Image(com.isPause ? "resume" : "pause")
                                        .btnStyle(SMALL_BTN_SIZE)
                                }
                                .padding(DECALAGE_BORDURE)
                            }
                            Spacer().frame(height: 8)
                        }
                        .frame(alignment: .bottom)
                    } else { // phase fin de sequence
                        VStack {
                            Spacer()
                            Theme()
                            Spacer()
                            Text(com.noteFinale)
                                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
                            if com.sansFaute  {
                                Temps2020(departChrono20: com.departChrono20, elapsedTime: com.elapsedTime)
                            }
                            List(com.listeCorr) { ligne in
                                ZStack {
                                    Image("index")
                                        .resizable(resizingMode: .stretch)
                                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                                    HStack() {
                                        Text(ligne.tirageFaux)
                                            .foregroundColor(.red)
                                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        Spacer(minLength: BTN_SIZE + 16)
                                        Text(ligne.motCorrect.mot!.refOds!.graphie!)
                                            .lineLimit(1)
                                            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    }
                                }
                                .listRowBackground(Color("fondbleu"))
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    accMotAffiche = nil
                                    motAffiche = ligne.motCorrect.mot!
                                }
                            }
                            Spacer()
                            Button() {
                                com.isInterro = false
                                self.dismiss()
                            } label:{
                                Image("quitter")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width:BTN_SIZE, height:BTN_SIZE )
                            }
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .top)
                .background(Color("fondbleu").ignoresSafeArea())
                .scrollContentBackground(.hidden)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                InfoBase()
            }
            .padding(8)
            if com.message != "" {
                Message()
            }
        }
        .background(Color("fondbleufonce").ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .persistentSystemOverlays(.hidden)
        .ignoresSafeArea(.keyboard, edges: .all)  
        .onAppear() {
            com.elapsedTime = 0
            com.listeCorr.removeAll()
            getAcc(mot: com.motAtrouver!.mot!)
            com.departChrono20 = Date.now
            com.phase = .user
        }
    }
    private func updateSucces(mot: Mot) {
        accMotAffiche = accNext
        motAffiche = mot
        let motUpdate = mot as NSManagedObject
        resultat = com.indiceConsomme ? .ok : .succes
        com.totalCoups += 1
        motUpdate.setValue(com.totalCoups, forKey: "nChrono")
        motUpdate.setValue(mot.nEssai + 1, forKey: "nEssai")
        
        let sqSuc = mot.sqSucces + 1
        if sqSuc > seqSucc {
            if(mot.baseActive) { // avec l'option mots proches, des mots désactivés peuvent apparaître. Pas besoin de les désactiver
                motUpdate.setValue(false, forKey: "baseActive")
                com.baseActive -= 1
                com.message = String(localized: "\(mot.refOds!.graphie!) désactivé")
            }
        } else if !com.indiceConsomme {
            motUpdate.setValue(sqSuc, forKey: "sqSucces")
        }
        saveContext(context: viewContext)
    }
    
    private func updateFail(mot: Mot) {
        accMotAffiche = accNext
        motAffiche = mot
        let motUpdate = mot as NSManagedObject
        resultat = .echec
        com.totalCoups += 1
        motUpdate.setValue(com.totalCoups, forKey: "nChrono")
        motUpdate.setValue(mot.nEssai + 1, forKey: "nEssai")
        motUpdate.setValue(mot.nEchec + 1, forKey: "nEchec")
        motUpdate.setValue(0, forKey: "sqSucces")
        if (!mot.baseActive) {
            com.message = String(localized: "\(mot.refOds!.graphie!) réactivé")
            motUpdate.setValue(true, forKey: "baseActive")
            motUpdate.setValue(mot.nSession + 1, forKey: "nSession")
        }
        saveContext(context: viewContext)
    }
    func getAcc(mot: Mot) {
        DispatchQueue.global().async {
            accNext = MilleMots.getAcc(context: viewContext, mot: mot)
            DispatchQueue.main.async {
                com.anaList = accNext!.ana
            }
        }
    }
}
