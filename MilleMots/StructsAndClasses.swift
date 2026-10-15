//
//  StructsAndClasses.swift
//  MilleMots
//
//  Created by Simon Wintz on 20/11/2025.
//

import Foundation

struct MotAtrouver {
    var mot: Mot? = nil
    var tirage: String = ""
    init(mot: Mot) {
        self.mot = mot
        self.tirage = mot.refOds?.spectre ?? ""
    }
    init(mot: Mot, tirage: String) {
        self.mot = mot
        self.tirage = tirage
    }
}

struct LigneCorr: Identifiable {
    let id = UUID()
    let tirageFaux: String
    let motCorrect: MotAtrouver
}

struct Accessoires: Equatable {
    var ana : [String] = []
    var rac : [String] = []
    var ext : [String] = []
    
    init() {
        self.ana = []
        self.rac = []
        self.ext = []
    }
    
    init(ana: [String], rac: [String], ext: [String]) {
        self.ana = ana
        self.rac = rac
        self.ext = ext
    }
}
    
struct ImportItem: Identifiable {
    let id = UUID()
    let mots: String
    let motsList: [String]
    let def: String
    init(mots: String, def: String) {
        self.mots = mots
        self.def = def
        self.motsList = mots.components(separatedBy: " ").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    }
}

struct Elimot: Equatable {
    var motDic : String = ""
    var defElimots : String = ""
    var def : String = ""
    var mots : String = ""
    var message : String = ""
}
