//
//  JeuSet.swift
//  MilleMots
//
//  Created by Simon Wintz on 31/01/2025.
//

import Foundation


/*
 class JeuSet : ObservableObject {
 @Published var motsAtrouver = [Mot]()
 @Published var listeCorr = [LigneCorr]()
 @Published var departChrono20 : Date = Date.now
 @Published var elapsedTime : Int = 0
 @Published var indiceConsomme : Bool = false
 @Published var phase : Phase = .user
 @Published var anaList = [String]()
 @Published var nnTirages : Int = 0
 @Published var horsDelai : Bool = false
 @Published var essais = [String]()
 var isMotProche: [Bool] = []
 var indexMotAtrouver : Int = 0
 var reglette : String = ""
 
 var motAtrouver : Mot {
 return motsAtrouver[indexMotAtrouver]
 }
 var defMotAtrouver : String {
 self.indiceConsomme = true
 return motAtrouver.definition!.enonce!
 }
 var pasFini : Bool {
 return self.indexMotAtrouver < self.nnTirages - 1
 }
 var progress : Float {
 return Float(min(self.indexMotAtrouver + 1, self.nnTirages))/Float(self.nnTirages)
 }
 var noteFinale : String {
 let nErr = self.listeCorr.count
 let car = (nErr == 0 ? ETOILES : "")
 return "\(car) \(self.nnTirages - nErr) / \(self.indexMotAtrouver + 1) \(car)"
 }
 var sansFaute : Bool {
 return self.numeroCoup == N_TIRAGE_RECORD && self.listeCorr.count == 0
 }
 func nextMot() {
 self.indexMotAtrouver += 1
 self.indiceConsomme = false
 }
 func addCorr(mot : Mot) {
 self.listeCorr.append(LigneCorr(tirageFaux: self.reglette + (self.horsDelai ? "\n(hors délai)" : ""), motCorrect: mot))
 }
 var dejaTente : Bool {
 self.essais.contains(self.reglette) && !self.horsDelai
 }
 var anagramme : Bool {
 if self.anaList.contains(self.reglette) && !self.horsDelai {
 self.essais.append(self.reglette)
 return true
 }
 else { return false }
 }
 var motProche : Bool {
 return isMotProche.isEmpty ? false : self.isMotProche[self.indexMotAtrouver]
 }
 func reinitSequence() {
 self.motsAtrouver.removeAll()
 self.isMotProche.removeAll()
 self.indexMotAtrouver = 0
 }
 func addMotsAtrouver(mots: [Mot]) {
 self.isMotProche.append(false)
 self.isMotProche.append(contentsOf: Array(repeating: true, count: mots.count - 1))
 self.motsAtrouver.append(contentsOf: mots)
 }
 var nouvellePartie : Bool {
 return self.indexMotAtrouver == 0
 }
 var numeroCoup : Int {
 return self.indexMotAtrouver + 1
 }
 var success : Bool {
 return self.reglette == self.motAtrouver.refOds!.graphie
 }
 func setReglette(reg:String) {
 self.reglette = reg
 }
 }
 */
