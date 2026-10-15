//
//  Jeu.swift
//  MilleMots
//
//  Created by Simon Wintz on 26/03/2024.
//

import CoreData
import Foundation
import SwiftUI

/*

 struct Jeu: View {
 @EnvironmentObject var jeu: JeuSet
 @State var motAffiche: Mot?
 @State var accMotAffiche = Accessoires()
 @State var accNext = Accessoires()
 @State var nChrono : Int = 0
 @State var totBaseActive : Int = 0
 @State var resultat = Resultat.ok
 @State var jeuEnCours = true
 @State var nTot : Int = 0
 @State var predicate : NSPredicate = REQUETE_PLEINE
 @State var presenceUser : Bool = true
 @EnvironmentObject var com : Com
 @AppStorage(USER_SEQ_SUCC) var seqSucc : Int = DEFAULT_SEQ_SUCC
 @AppStorage(USER_N_TIRAGES) var nTirages : Int = DEFAULT_N_TIRAGES
 @AppStorage(USER_N_SESS) var nSess : Int = DEFAULT_N_SESS
 @AppStorage(USER_OPTION_MOTS_PROCHES) var optionProches : Bool = false

 @Environment(\.dismiss) var dismiss
 @Environment(\.managedObjectContext) private var viewContext

 @FetchRequest(entity: Mot.entity(), sortDescriptors: [], predicate: NSPredicate(format: "motMort == NO"))
 private var mots: FetchedResults<Mot>
 @FetchRequest(entity: Ods9.entity(), sortDescriptors: [])
 private var ods: FetchedResults<Ods9>

 var body: some View {
 ZStack {
 VStack (spacing: 0) {
 DetailsMot(mot: $motAffiche, acc: $accMotAffiche, resultat: resultat)
 .onChange(of: motAffiche) {
 if motAffiche == nil {
 resultat = .ok
 }
 }
 Spacer()
 .frame(height: 8)
 ZStack (alignment: .topLeading) {
 if jeuEnCours { // phase jeu
 VStack {
 JeuView(
 motAffiche: $motAffiche,
 presenceUser: $presenceUser,
 theme: VIDE
 )
 .onChange(of: jeu.phase, initial: true) {
 if jeu.phase == .ordi {
 if jeu.success {
 updateSucces(mot: jeu.motAtrouver)
 } else if presenceUser {
 updateFail(mot: jeu.motAtrouver)
 } else {
 self.dismiss()
 }
 if jeu.pasFini {
 jeu.nextMot()
 getAcc(mot: jeu.motAtrouver)
 jeu.horsDelai = false
 jeu.phase = .joueur
 } else {
 DispatchQueue.main.asyncAfter(deadline: .now() + DELAI_SORTIE) {
 resultat = .ok
 motAffiche = nil
 self.jeuEnCours = false
 }
 }
 }
 }
 Spacer().frame(height: 8)
 HStack {
 ProgressView(value: jeu.progress)
 .padding(6)
 Button() {
 jeu.elapsedTime += Int(Date.now.timeIntervalSince(jeu.departChrono20))
 self.dismiss()
 } label:{
 Image("cancel")
 .resizable(resizingMode: .stretch)
 .frame(width:SMALL_BTN_SIZE, height:SMALL_BTN_SIZE )
 .padding(6)
 }
 }
 Spacer().frame(height: 8)
 }
 .frame(alignment: .bottom)
 } else { // phase fin de sequence
 VStack {
 Spacer()
 Text(jeu.noteFinale)
 .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
 if jeu.sansFaute  {
 Temps2020(departChrono20: jeu.departChrono20, elapsedTime: jeu.elapsedTime)
 }
 List(jeu.listeCorr) { ligne in
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
 Text(ligne.motCorrect.refOds!.graphie!)
 .lineLimit(1)
 .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
 }
 }
 .listRowBackground(Color("fondbleu"))
 .listRowSeparator(.hidden)
 .onTapGesture {
 motAffiche = ligne.motCorrect
 accMotAffiche = Accessoires()
 displayAcc(mot: ligne.motCorrect)
 }
 }
 Spacer()
 Button() {
 jeu.reinitSequence()
 self.dismiss()
 } label:{
 Image("quitter")
 .resizable(resizingMode: .stretch)
 .frame(width:BTN_SIZE, height:BTN_SIZE )
 }
 Spacer()
 }
 }
 if com.message != "" {
 Message()
 }
 }
 .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .top)
 .background(Color("fondbleu"))
 .scrollContentBackground(.hidden)
 .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
 .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
 .overlay(
 RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
 InfoBase()
 }
 .padding(8)
 }
 .background(Color("fondbleufonce"))
 .navigationBarBackButtonHidden()
 .persistentSystemOverlays(.hidden)
 .onAppear() {
 startJeu()
 }
 }

 func startJeu() {
 if jeu.nouvellePartie { // nouvelle partie
 getMotsATrouver()
 jeu.listeCorr.removeAll()
 jeu.elapsedTime = 0
 }
 getAcc(mot: jeu.motAtrouver)
 jeu.departChrono20 = Date.now
 jeu.phase = .user
 }

 func updateSucces(mot: Mot) {
 motAffiche = mot
 accMotAffiche = accNext
 let motUpdate = mot as NSManagedObject
 resultat = if jeu.indiceConsomme {.ok} else {.succes}
 nChrono += 1
 motUpdate.setValue(nChrono, forKey: "nChrono")
 motUpdate.setValue(mot.nEssai + 1, forKey: "nEssai")

 let sqSuc = mot.sqSucces + 1
 if sqSuc > seqSucc && totBaseActive > MIN_BASE_ACTIVE {
 if(mot.baseActive) { // avec l'option mots proches, des mots désactivés peuvent apparaître. Pas besoin de les désactiver
 if mot.nSession == nSess {
 motUpdate.setValue(true, forKey: "motMort")
 com.message = String(localized: "\(mot.refOds!.graphie!) acquis")
 }
 motUpdate.setValue(false, forKey: "baseActive")
 totBaseActive -= 1
 com.message = String(localized: "\(mot.refOds!.graphie!) désactivé")
 }
 } else if !jeu.indiceConsomme {
 motUpdate.setValue(sqSuc, forKey: "sqSucces")
 }
 saveContext(context: viewContext)
 }

 func updateFail(mot: Mot) {
 motAffiche = mot
 accMotAffiche = accNext
 let motUpdate = mot as NSManagedObject
 resultat = .echec
 nChrono += 1
 motUpdate.setValue(nChrono, forKey: "nChrono")
 motUpdate.setValue(mot.nEssai + 1, forKey: "nEssai")
 motUpdate.setValue(mot.nEchec + 1, forKey: "nEchec")
 motUpdate.setValue(0, forKey: "sqSucces")
 if (!mot.baseActive) {
 com.message = String(localized: "\(mot.refOds!.graphie!) réactivé")
 motUpdate.setValue(true, forKey: "baseActive")
 motUpdate.setValue(mot.nSession + 1, forKey: "nSession")
 }
 saveContext(context: viewContext)
 jeu.addCorr(mot: mot)
 }

 func getMotsATrouver() {
 jeu.reinitSequence()
 jeu.nnTirages = nTirages
 if optionProches {// option mots proches
 motsProches()
 // sequence de jeu standard
 if !jeu.listeCorr.isEmpty {
 jeu.motsAtrouver = jeu.listeCorr.map {$0.motCorrect}
 }
 repeat {
 let randomMot = mots.filter { $0.baseActive }.randomElement()
 if !jeu.motsAtrouver.contains(randomMot!) {
 jeu.motsAtrouver.append(randomMot!)
 }
 } while jeu.motsAtrouver.count < nTirages

 jeu.motsAtrouver.shuffle()
 }
 }

 func motsProches() {
 if let randomMot = (mots.filter {$0.baseActive}.randomElement()) {
 jeu.motsAtrouver.append(randomMot)
 repeat {
 jeu.motsAtrouver.append(nextMotProche())
 } while (jeu.motsAtrouver.count < nTirages)
 }
 }
 func nextMotProche() -> Mot {
 let lastMot = jeu.motsAtrouver.last!.refOds!.graphie!
 let distances = mots
 .filter { !jeu.motsAtrouver.contains($0) }
 .map {(mot: $0, distance: levenshtein(Array(lastMot), Array($0.refOds!.graphie!)))}
 .sorted(by:{$0.distance < $1.distance})
 let distMini = distances.first!.distance
 return distances.filter {$0.distance == distMini}.map(\.mot).randomElement()!
 }

 func displayAcc(mot: Mot) {
 Task {
 accMotAffiche = await asyncGetAc(context: viewContext, mot: mot)
 }
 }
 func getAcc(mot: Mot) {
 Task {
 accNext = await asyncGetAc(context: viewContext, mot: mot)
 jeu.anaList = accNext.ana.delPrefix(PREFIX_ANA).components(separatedBy: ", ")
 }
 }
 }

*/
