//
//  EnumAndClasses.swift
//  MilleMots
//
//  Created by Simon Wintz on 02/03/2026.
//

import Foundation
import SwiftUI

struct DataObject: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let payload: String
    
    init(name: String, payload: String = VIDE) {
        self.name = name
        self.payload = payload
    }
}

enum OptionJeu: String, CaseIterable, Equatable {
    case basique = "Basique"
    case motsProches = "Mots proches"
    case anagrammes = "Anagrammes"
    case motPlusUn = "Mot+1"
}

enum Flag {
    case doublon, ok, inconnu
    var couleur: Color {
        return switch(self) {
        case .doublon: Color.black
        case .ok: Color.green
        case .inconnu: Color.red
        }
    }
}
enum Mode {
    case edition, ajout, ajoutGraphie, nonValide
    var couleur: Color {
        return switch(self) {
        case .nonValide: Color.red
        case .ajout: Color.green
        default : Color.black
        }
    }
}
enum ElementFiltre {
    case prefix, content, suffix, exclut
}
enum Generique {
    case deuxPlus, deux, trois, quatre, dix
    var letttres: String {
        switch self  {
            case .deuxPlus: return "DGMBCPFHVJQKWXYZ"
            case .deux: return "DGM"
            case .trois: return "BCP"
            case .quatre: return "FHV"
            case .dix: return "KWXYZ"
        }
    }
}
enum Entite {
    case Mot, Ods9
}
enum OrdreTri: Int {
    case alpha = 1, err, chrono, none
    static let allValues = [alpha, err, chrono, none]
    var image: Image {
        switch self {
        case .alpha: return Image("tri_alpha")
        case .err: return Image("tri_feux")
        case .chrono: return Image("exercice")
        case .none: return Image("tri_chrono")
        }
    }
    var next: OrdreTri {
        switch self {
        case .alpha: return .err
        case .err: return .chrono
        case .chrono: return .none
        case .none: return .alpha
        }
    }
    var sortDescriptor: [NSSortDescriptor] {
        // la liste des mots est inversée -> ordre de tris inversés
        return switch self {
        case .err:
            [NSSortDescriptor(key:"nEchec", ascending: true), NSSortDescriptor(key:"nEssai", ascending: true)]
        case .chrono:
            [NSSortDescriptor(key:"nChrono", ascending: true)]
        case .none:
            []
        case .alpha:
            [NSSortDescriptor(key:"refOds.graphie", ascending: false)]
        }
    }
}
enum Phase {
    case user, ordi, final
}
enum Resultat {
    case ana, dejaTente, succes, ok, echec
    var color: Color {
        switch self {
        case .succes: return Color("vert")
        case .echec: return .red
        default : return .black
        }
    }
    var ep: CGFloat {
        switch self {
        case .succes: return 3.0
        case .echec: return 3.0
        default: return 1.0
        }
    }
}
