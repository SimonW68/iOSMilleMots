//
//  DetailsMotN.swift
//  MilleMots
//
//  Created by Simon Wintz on 19/11/2025.
//
import Foundation
import SwiftUI
import CoreData

struct DetailsMot: View {
    var ods: Ods9?
    var mot: Mot?
    var graphie: String = ESPACE
    var acc: Accessoires?
    @State var def: String = ESPACE
    @State var ort: String = ESPACE
    @State var ana: [String] = []
    @State var ext: [String] = []
    @State var rac: [String] = []
    @State var elimot : Elimot = Elimot()
    var fgColor: Color
    let updateAcc: Bool
    @EnvironmentObject var del : Def
    @EnvironmentObject var com: Com
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.managedObjectContext) private var viewContext
    
    init(mot: Mot?, acc: Accessoires? = nil) {
        self.mot = mot
        self.acc = acc
        self.graphie = mot?.refOds?.graphie ?? ESPACE
        self.def = mot?.definition?.enonce ?? ESPACE
        self.ort = mot?.orthoAlt ?? ESPACE
        self.ana = acc?.ana ?? []
        self.ext = acc?.ext ?? []
        self.rac = acc?.rac ?? []
        self.fgColor = Color.black
        self.updateAcc = false
    }
    
    init(ods: Ods9) {
        self.ods = ods
        self.graphie = ods.graphie ?? ESPACE
        self.def = ods.mot?.definition?.enonce ?? VIDE
        self.ort = ods.mot?.orthoAlt ?? ESPACE
        self.fgColor = ods.mot != nil ? Color.black : Color("vert")
        self.updateAcc = true
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            VStack(alignment: .leading) {
                Text("\(graphie) ")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(fgColor)
                + Text(ort)
                    .font(.title3)
                    .foregroundColor(fgColor)
                Text(def)
                    .frame(maxWidth:.infinity, alignment:.leading)
                    .multilineTextAlignment(.leading)
                Acc(words: ana, prefix: PREFIX_ANA)
                Acc(words: rac, prefix: PREFIX_RAC)
                Acc(words: ext, prefix: PREFIX_EXT)
                Spacer()
                    .frame(height: DECALAGE_BORDURE)
            }
            .font(.body)
            .formatVue("fondbleu")
            .onChange(of: mot, initial: true ) {
                self.def = mot?.definition?.enonce ?? ESPACE
                self.ort = com.optionEnCours != .motsProches ? mot?.orthoAlt ?? ESPACE : ESPACE
                if acc != nil {
                    self.ana = acc!.ana
                    self.ext = acc!.ext
                    self.rac = acc!.rac
                } else {
                    ana = []
                    ext = []
                    rac = []
                    DispatchQueue.global().async {
                        ana = getAna(context: viewContext, ods: mot?.refOds)
                        ext = getExt(context: viewContext, ods: mot?.refOds)
                        rac = getRac(context: viewContext, ods: mot?.refOds)
                    }
                }
            }
            .onChange(of: ods, initial: true) {
                if updateAcc {
                    ana = []
                    ext = []
                    rac = []
                    def = ESPACE
                    ort = ESPACE
                    DispatchQueue.global().async {
                        ana = getAna(context: viewContext, ods: ods)
                        ext = getExt(context: viewContext, ods: ods)
                        rac = getRac(context: viewContext, ods: ods)
                    }
                    if ods != nil && networkMonitor.isConnected {
                        ConsultElimots().getDef(mot: ods!.graphie!) { elimot in
                            self.elimot = elimot
                        }
                    }
                }
            }
            .onChange(of: elimot) {
                self.def = elimot.def
                let o = elimot.mots.split(separator: " ").dropFirst().joined(separator: ", ")
                if !o.isEmpty {
                    self.ort = PREFIX_ORT + o
                }
                com.elimotMots = elimot.mots
                com.elimotDef = elimot.def
            }
            .onDisappear() {
                com.elimotMots = VIDE
                com.elimotDef = VIDE
            }
        }
    }
}
