//
//  Com.swift
//  MilleMots
//
//  Created by Simon Wintz on 27/10/2025.
//

import Foundation
import SwiftUI

class Com: ObservableObject {
    @Published var actifsOnly: Bool = true
    @Published var anaList = [String]()
    @Published var baseActive: Int = .zero
    @Published var departChrono20: Date = Date.now
    @Published var displayKbd: Bool = false
    @Published var displayOds: Bool = false
    @Published var elapsedTime: Int = 0
    @Published var elimotDef: String = VIDE
    @Published var elimotMots : String = VIDE
    @Published var enableReglette: Bool = true
    @Published var essais = [String]()
    @Published var horsDelai: Bool = false
    @Published var indiceConsomme: Bool = false
    @Published var isInterro: Bool = false
    @Published var isPause: Bool = false
    @Published var listeCorr = [LigneCorr]()
    @Published var message: String = VIDE
    @Published var preMotsAtrouver = [MotAtrouver]()
    @Published var motsAtrouver = [MotAtrouver]()
    @Published var phase: Phase = .user
    @Published var largScreen : CGFloat = 0.0
    @Published var path = NavigationPath()
    @Published var predicateMots: NSPredicate = REQUETE_PAR_DEFAUT
    @Published var predicateOds: NSPredicate = REQUETE_VIDE
    @Published var pret: Bool = false
    @Published var tauxSucces: Double = .zero
    @Published var timerSteps: Int = 0
    @Published var totalBase: Int = .zero
    @Published var totalCoups: Int = .zero
    @Published var totalFiltre: Int = .zero
    @Published var totalOds: Int = .zero
    @Published var showPlusUn : Bool = false
    @Published var getMotsAtrouver: Bool = false
    @Published var url : URL?
    @Published var saveFile: Bool = false
    @AppStorage(CUR_OPTION) var optionEnCours: OptionJeu = .basique
    @AppStorage(FILTRE_L_MAX) var lMax: Int = LONGUEUR_MOT_MAX
    @AppStorage(FILTRE_L_MIN) var lMin: Int = LONGUEUR_MOT_MIN
    @AppStorage(USER_nTirages) var nTirages : Int = DEFAULT_nTirages
    @AppStorage(FILTRE_STR_PREF) var strPref: String = VIDE
    @AppStorage(FILTRE_STR_CONT) var strCont: String = VIDE
    @AppStorage(FILTRE_STR_SUF) var strSuff: String = VIDE
    @AppStorage(FILTRE_STR_EXCL) var strExcl: String = VIDE
    @AppStorage(MONOMES_ONLY) var monomesOnly: Bool = false
    @AppStorage(OPTION_RAPIDE) var optionRapide: Bool = false

    func addCorr(mot: MotAtrouver) {
        self.listeCorr.append(
            LigneCorr(
                tirageFaux: self.reglette + (self.horsDelai ? "\n(hors délai)" : ""),
                motCorrect: mot
            )
        )
    }
    var anagramme: Bool {
        if self.anaList.contains(self.reglette) && !self.horsDelai {
            self.essais.append(self.reglette)
            return true
        } else {
            return false
        }
    }
    func clearQuery() {
        strPref = VIDE
        strCont = VIDE
        strSuff = VIDE
        strExcl = VIDE
        lMin = LONGUEUR_MOT_MIN
        lMax = LONGUEUR_MOT_MAX
        monomesOnly = false
        actifsOnly = true
        displayOds = false
        applyFilter()
    }
    var colonnes: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: Int(UIScreen.main.bounds.width / 180.0))
    }
    var dejaTente: Bool {
        self.essais.contains(self.reglette) && !self.horsDelai
    }
    var defMotAtrouver: String {
        self.indiceConsomme = true
        return motAtrouver!.mot!.definition!.enonce!
    }
    func descriptionFiltre() -> [String] {
        let premLignePref = "Tous les \(monomesOnly ? "monomes" : "mots") "
        let premLigneSuff = "\(!displayOds ? "de votre base\(actifsOnly ? " active " : VIDE)" : "hors base ")"
        var strElements: [String] = []
        if lMin != LONGUEUR_MOT_MIN || lMax != LONGUEUR_MOT_MAX {
            strElements.append(" de \(lMin)\(lMax != lMin ? " à \(lMax)" : VIDE) lettres")
        }
        if !strPref.isEmpty {strElements.append("commençant par \(strPref.postTraitement)")}
        if !strCont.isEmpty {strElements.append("contenant \(strCont.postTraitement)")}
        if !strSuff.isEmpty {strElements.append("finissant par \(strSuff.postTraitement)")}
        if !strExcl.isEmpty {strElements.append("ne contenant pas \(strExcl.etToNi.postTraitement)")}
        let laSuite = strElements.joined(separator: " ")
        return [premLignePref, premLigneSuff, laSuite]
    }
    let grandEcran: Bool = UIScreen.main.bounds.width > GRD_ECRAN
    var indexMotAtrouver : Int {
        return nTirages - self.motsAtrouver.count + 1
    }
    var isLoadingOds: Bool {
        return predicateOds != REQUETE_VIDE && totalOds == 0
    }
    var largView: Double {
        largScreen - 4 * DECALAGE_BORDURE
    }
    var motAtrouver: MotAtrouver? {
        return motsAtrouver.first
    }
    func nextMot() -> Bool {
        guard motsAtrouver.count > 1 else {
            return false
        }
        self.motsAtrouver.removeFirst()
        self.indiceConsomme = false
        self.horsDelai = false
        self.phase = .user
        return true
    }
    var noteFinale: String {
        let nErr = self.listeCorr.count
        let car = (nErr == 0 ? ETOILES : "")
        return "\(car) \(nTirages - nErr) / \(nTirages) \(car)"
    }
    var numeroCoup: Int {
        return nTirages - motsAtrouver.count + 1
    }
    var pasLettre: Double {
        largView / Double(LONGUEUR_MOT_MAX)
    }
    func pause(_ on: Bool) {
        isPause = on
        if isPause {
            elapsedTime += Int(Date.now.timeIntervalSince(departChrono20))
        } else {
            departChrono20 = Date.now
        }
    }
    var progress: Double {
        TIMER_INTERVAL * Double(timerSteps) / Double(optionRapide ? TIMER_TIME_COURT : TIMER_TIME_LONG)
    }
    var progressInterro : Float {
        return Float(indexMotAtrouver)/Float(nTirages)
    }
    var reglette: String = ""
    var requeteVide: Bool {
        strPref.isEmpty && strCont.isEmpty && strSuff.isEmpty && strExcl.isEmpty && lMin == LONGUEUR_MOT_MIN && lMax == LONGUEUR_MOT_MAX
    }
    func setTotalOds(_ value : Int = 0) {
        totalOds = value
    }
    var sansFaute : Bool {
        return self.listeCorr.count == 0
    }
    func setReglette(reg: String) {
        self.reglette = reg
    }
    var success: Bool {
        return self.reglette == self.motAtrouver!.mot!.refOds!.graphie
    }
    var tempsEcoule: Int {
        timerSteps / Int(1 / TIMER_INTERVAL)
    }
    var tuileSize: Double {
        return pasLettre - EP_FILET
    }
    // FILTRES
    func applyFilter() {
        pret = false
        predicateMots = applyFilterMots()
        predicateOds =  requeteVide ? REQUETE_VIDE : applyFilterOds()
    }
    private func applyFilterMots() -> NSPredicate {
        let p = filtreCompose(entite: .Mot)
        let q = NSPredicate(format: "motMort == NO" + (monomesOnly ? " && refOds.nAna == 1" : VIDE) + (actifsOnly ? " && baseActive == YES": VIDE))
        return NSCompoundPredicate(type: .and, subpredicates: [p, q])
    }
    func applyFilterOds() -> NSPredicate {
        let p = filtreCompose(entite: .Ods9)
        let r = NSPredicate(format: "mot == nil && nonConjFemPlu == YES" + (monomesOnly ? " && nAna == 1" : ""))
        return NSCompoundPredicate(type: .and, subpredicates: [p, r])
    }
    private func filtreCompose(entite: Entite) -> NSPredicate {
        return NSCompoundPredicate(type: .and, subpredicates: [
            filterByLength(entite: entite),
            filterByElement(element: .prefix, entite: entite),
            filterByElement(element: .content, entite: entite),
            filterByElement(element: .suffix, entite: entite),
            filterByElement(element: .exclut, entite: entite)
        ])
    }
    private func filterByLength(entite: Entite) -> NSPredicate {
        return NSPredicate(format: (entite == .Mot ? "refOds." : "") + "graphie MATCHES %@" , ".{\(lMin),\(lMax)}")
    }
    private func filterByElement(element: ElementFiltre, entite: Entite) -> NSPredicate {
        var strElem = switch element {
        case .prefix : strPref
        case .suffix : strSuff
        case .content : strCont
        case .exclut : strExcl
        }
        guard !strElem.isEmpty else { return REQUETE_PLEINE }
        let qSansU : Bool = strElem.contains("q")
        let etOu : Bool = !strElem.contains("o")
        
        var elemPredicates = [NSPredicate]()
        
        if element == .content && etOu || element == .exclut {
            for gen in GENERIQUES { // lorsque le contenu contient un element générique (donc lien OU) dans un filtre de type ET
                let elemGens : String = switch gen {
                    case "v" : LETTRES_PAS_VELOS
                    case DEUX : LETTRES_A_2
                    case TROIS : LETTRES_A_3
                    case QUATRE : LETTRES_A_4
                    case "d" : LETTRES_A_10
                    default : VIDE
                }
                if strElem.contains("2" + gen) { // générique avec un multiplicateur (2)
                    strElem = strElem.replacingOccurrences(of: "2" + gen, with: "")
                    var combPredicates = [NSPredicate]()
                    let combinaisons = combi(lettres: elemGens, n: 2)
                    for comb in combinaisons {
                        combPredicates.append(NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie LIKE %@", comb))
                    }
                    elemPredicates.append (NSCompoundPredicate(type: .or, subpredicates: combPredicates))
                } else if strElem.contains("3" + gen) { // générique avec un multiplicateur (3)
                    strElem = strElem.replacingOccurrences(of: "3" + gen, with: "")
                    var combPredicates = [NSPredicate]()
                    let combinaisons = combi(lettres: elemGens, n: 3)
                    for comb in combinaisons {
                        combPredicates.append(NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie LIKE %@", comb))
                    }
                    elemPredicates.append (NSCompoundPredicate(type: .or, subpredicates: combPredicates))
                } else if strElem.contains("4" + gen) { // générique avec un multiplicateur (4)
                    strElem = strElem.replacingOccurrences(of: "4" + gen, with: "")
                    var combPredicates = [NSPredicate]()
                    let combinaisons = combi(lettres: elemGens, n: 4)
                    for comb in combinaisons {
                        combPredicates.append(NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie LIKE %@", comb))
                    }
                    elemPredicates.append (NSCompoundPredicate(type: .or, subpredicates: combPredicates))
                } else if strElem.contains(gen) { // générique sans multiplicateur
                    strElem = strElem.replacingOccurrences(of: gen, with: "")
                    var genPredicates = [NSPredicate]()
                    for elemGen in elemGens {
                        switch element {
                            case .content :
                            genPredicates.append(NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie CONTAINS[c] %@", String(elemGen)))
                            case .exclut :
                            genPredicates.append(NSPredicate(format: "NOT " + (entite == .Mot ? "refOds." : VIDE) + "graphie CONTAINS[c] %@", String(elemGen)))
                        default : break
                        }
                    }
                    elemPredicates.append(NSCompoundPredicate(type: element == .exclut ? .and : .or, subpredicates: genPredicates))
                }
            }
        }
        let elems = strElem
            .replacingOccurrences(of: "q", with: "Q")
            .replacingOccurrences(of: "v", with: Array(LETTRES_PAS_VELOS).map(String.init).joined(separator: etOu ? "e" : "o"))
            .replacingOccurrences(of: DEUX, with: Array(LETTRES_A_2).map(String.init).joined(separator: etOu ? "e" : "o"))
            .replacingOccurrences(of: TROIS, with: Array(LETTRES_A_3).map(String.init).joined(separator: etOu ? "e" : "o"))
            .replacingOccurrences(of: QUATRE, with: Array(LETTRES_A_4).map(String.init).joined(separator: etOu ? "e" : "o"))
            .replacingOccurrences(of: "d", with: Array(LETTRES_A_10).map(String.init).joined(separator: etOu ? "e" : "o"))
            .split(separator: etOu ? "e" : "o")

        for elem in elems {
            var p = NSPredicate()
            guard let premC = elem.first else { continue }
            if let multi = premC.wholeNumberValue { // element numérique -> multiplicateur
                let elemNet = elem.dropFirst().trimmingCharacters(in: .whitespaces)
                if GENERIQUES.contains(elemNet) {
                    var combPredicates = [NSPredicate]()
                    let combinaisons = combi(lettres: elemNet, n: multi)
                    for comb in combinaisons {
                        combPredicates.append(NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie LIKE %@", comb))
                    }
                    p = NSCompoundPredicate(type: .or, subpredicates: combPredicates)
                } else {
                    var pat = WILDCARD + elemNet + WILDCARD + elemNet + WILDCARD
                    if multi > 2 {
                        pat += elemNet + WILDCARD
                    }
                    if multi > 3 {
                        pat += elemNet + WILDCARD
                    }
                    p = NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie LIKE %@", pat )
                }
            } else {
                p = switch element {
                case .prefix : NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie BEGINSWITH %@", String(elem))
                case .suffix : NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie ENDSWITH %@", String(elem))
                case .content : NSPredicate(format: (entite == .Mot ? "refOds." : VIDE) + "graphie CONTAINS[c] %@", String(elem))
                case .exclut : NSPredicate(format: "NOT " + (entite == .Mot ? "refOds." : VIDE) + "graphie CONTAINS[c] %@", String(elem))
                }
            }
            elemPredicates.append(p)
        }
        var predicate = NSCompoundPredicate(type: etOu ? .and : .or, subpredicates: elemPredicates)
        if qSansU {
            let p = NSPredicate(format: "NOT " + (entite == .Mot ? "refOds." : VIDE) + "graphie CONTAINS[c] %@", "QU")
            predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate, p])
        }
        return predicate
    }
}
