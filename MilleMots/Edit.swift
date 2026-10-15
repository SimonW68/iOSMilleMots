//
//  Edit.swift
//  MilleMots
//
//  Created by Simon Wintz on 09/12/2025.
//

import Foundation
import SwiftUI
import CoreData

struct Edit: View {
    @State var motRecherche: String
    @State var motEnCours: Mot?
    @State var newOds: Ods9?
    @State var odsEnCours: Ods9?
    @State var newGraphie: String = VIDE
    @State var mots: String = VIDE
    @State var def: String = VIDE
    @State var dispNewGraphie: Bool = false
    @State var mode: Mode = .nonValide
    @State var flag: Flag = .inconnu
    @State var elimot : Elimot = Elimot()
    @State var ba: Bool = true
    @State var mm: Bool = false
    @State var alertSuppr: Bool = false
    @State var alertAdd: Bool = false
    @State var premierMot: Bool = true
    @EnvironmentObject var com : Com
    @FocusState private var focusedField: FocusedFields?
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    let set = CharacterSet(charactersIn: ALLOWED_CAR_EDIT)
    enum FocusedFields {
        case motRecherche, newGraphie, def
    }
    var body: some View {
        ZStack() {
            VStack() {
                VStack {
                    HStack {
                        Text(LOUPE)
                            .padding(10)
                        TextField(VIDE, text: $motRecherche)
                            .foregroundColor(mode.couleur)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                            .autocorrectionDisabled()
                            .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxLarge/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .focused($focusedField, equals: .motRecherche)
                            .onChange(of: motRecherche, initial: true) { newValue, oldValue in
                                motRecherche = motRecherche.filter(ALLOWED_CAR_EDIT.contains)
                                if motRecherche.count > LONGUEUR_MOT_MAX {
                                    motRecherche = String(motRecherche.dropLast())
                                }
                                if motRecherche.count < LONGUEUR_MOT_MIN {
                                    toInvalidMode()
                                } else if let odsRef =  getOdsRef(context: viewContext, mot: motRecherche) {
                                    if odsRef.mot != nil {
                                        if premierMot {
                                            motRecherche += " "
                                            premierMot = false
                                        } else {
                                            toEditMode(mot: odsRef.mot!)
                                        }
                                    } else {
                                        if premierMot {
                                            motRecherche += " "
                                            premierMot = false
                                        } else {
                                            toAddMode(ods: odsRef)
                                        }
                                    }
                                } else {
                                    toInvalidMode()
                                }
                            }
                    }
                    .formatVue("fondbleu")
                    .padding(.horizontal, 20)
                    .onChange(of: elimot) {
                        self.def = elimot.def
                        if elimot.mots.contains(motRecherche) {
                            self.mots = elimot.mots
                        } else {
                            // forme fléchie (ex. VARA → VARUS) : on ajoute le mot tapé avec sa forme de base
                            self.mots = motRecherche.trimmingCharacters(in: .whitespaces) + " " + elimot.mots
                        }
                    }
                    VStack {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack() {
                                    TextField(VIDE, text: $mots)
                                        .foregroundColor(mode.couleur)
                                        .disabled(mode != .ajout)
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxLarge/*@END_MENU_TOKEN@*/)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    Spacer()
                                        .frame(width: DECALAGE_BORDURE)
                                    ZStack(alignment: .topLeading) {
                                        TextField(VIDE, text: $newGraphie)
                                            .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                                            .autocorrectionDisabled()
                                            .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxLarge/*@END_MENU_TOKEN@*/)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                            .focused($focusedField, equals: .newGraphie)
                                            .foregroundColor(flag.couleur)
                                            .toolbar {
                                                ToolbarItemGroup(placement: .keyboard) {
                                                    if mode == .ajout {
                                                        Button() {
                                                            focusedField = nil
                                                            alertAdd = true
                                                        } label: {
                                                            Image("ajouter")
                                                                .btnStyle()
                                                        }
                                                    }
                                                    Spacer()
                                                    Button(CANCEL) {
                                                        focusedField = nil
                                                    }
                                                }
                                            }
                                            .onChange(of: newGraphie) {
                                                newGraphie = newGraphie.filter(ALLOWED_CAR_EDIT.contains)
                                                if newGraphie.count > LONGUEUR_MOT_MAX {
                                                    newGraphie = String(newGraphie.dropLast())
                                                }
                                                if let odsRef = getOdsRef(context: viewContext, mot: newGraphie){
                                                    if odsRef.mot != nil {
                                                        newOds = nil
                                                        flag = .doublon
                                                    } else {
                                                        newOds = odsRef
                                                        flag = .ok
                                                    }
                                                } else {
                                                    newOds = nil
                                                    flag = .inconnu
                                                }
                                            }
                                        if mode == .edition {
                                            Button("nouvelle graphie"){
                                                mode = .ajoutGraphie
                                                focusedField = .newGraphie
                                            }
                                            .padding(5)
                                            .font(.caption)
                                            .italic()
                                            .background(Color("fondbleufonce"))
                                            .cornerRadius(15)
                                        }
                                    }
                                }
                            }
                            if flag == .ok {
                                Spacer()
                                Button(){
                                    let newMot = Mot(context: viewContext)
                                    newMot.definition = motEnCours!.definition
                                    newMot.refOds = newOds
                                    saveContext(context: viewContext)
                                    com.message = "\(newOds!.graphie!) ajouté à la base"
                                    newGraphie = VIDE
                                    focusedField = .motRecherche
                                    motRecherche = newOds!.graphie!
                                } label : {
                                    Image("plus")
                                        .btnStyle()
                                }
                            }
                        }
                        TextField(VIDE, text: $def, axis: .vertical)
                            .focused($focusedField, equals: .def)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(3, reservesSpace: true)
                    }
                    .formatVue("fondbleu")
                    .onChange(of:elimot) {
                        def = elimot.def
                    }
                    Spacer()
                        .frame(height: 20)
                    Group {
                        if enableSwitches {
                            HStack {
                                Toggle("Actif : ", isOn: $ba)
                                Spacer()
                                Toggle("Acquis : ", isOn: $mm)
                            }
                        } else {
                            Text("")
                        }
                    }
                    .frame(height: 40)
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Button() {
                            newGraphie = VIDE
                            focusedField = .motRecherche
                            motRecherche = VIDE
                        } label: {
                            Image("cancel")
                                .btnStyle()
                        }
                        .opacity(enableCancelBtn ? 1 : 0)
                        .frame(maxWidth: .infinity)
                        Button() {
                            alertSuppr = true
                        } label: {
                            Image("trash")
                                .btnStyle()
                        }
                        .opacity(enableDelBtn ? 1 : 0)
                        .frame(maxWidth: .infinity)
                        ZStack {
                            Button(RETURN) {
                                if motEnCours != nil {
                                    if ba != motEnCours?.baseActive || mm != motEnCours?.motMort{
                                        let motUpdate = motEnCours! as NSManagedObject
                                        motUpdate.setValue(ba, forKey: "baseActive")
                                        motUpdate.setValue(mm, forKey: "motMort")
                                        if ba {
                                            motUpdate.setValue(0, forKey: "sqSucces")
                                            motUpdate.setValue(motEnCours!.nSession + 1, forKey: "nSession")
                                        }
                                    }
                                    if def != motEnCours!.definition?.enonce {
                                        let defUpdtae = motEnCours!.definition! as NSManagedObject
                                        defUpdtae.setValue(def, forKey: "enonce")
                                    }
                                    saveContext(context: viewContext)
                                    com.message = "\(motEnCours!.refOds!.graphie!) mis à jour"
                                }
                            }
                            .opacity(enableSaveEditBtn ? 1 : 0)
                            Button() {
                                alertAdd = true
                            } label: {
                                Image("ajouter")
                                    .btnStyle()
                            }
                            .opacity(enableSaveNewBtn ? 1 : 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 50)
                    .overlay(
                        Button(CANCEL) {
                            self.dismiss()
                        },
                        alignment: .bottomTrailing
                    )
                }
                .formatVue()
                .padding()
                .onAppear {
                    if motRecherche.isEmpty {
                        focusedField = .motRecherche
                    }
                }
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .background(Color("fondbleufonce").ignoresSafeArea())

            com.message != VIDE ? Message() : nil
            if alertSuppr {
                let snackMessage = String(motEnCours?.refOds?.graphie ?? VIDE)
                let labelAction = String(localized: "S U P P R I M E R")
                SnackBar(message: snackMessage, labelAction: labelAction, isLong: false, action: {
                    deleteMot(context: viewContext, mot: motEnCours!)
                    self.dismiss()
                }, endSnack: {
                    alertSuppr = false
                })
            }
            if alertAdd {
                let snackMessage = String(mots)
                let labelAction = String(localized: "A J O U T E R")
                SnackBar(message: snackMessage, labelAction: labelAction, isLong: false, action: {
                    alertAdd = false
                    let nm = addMots(context: viewContext, mots: mots, def: def)
                    let s = nm > 1 ? "s" : ""
                    com.message = "\(nm) mot\(s) ajouté\(s) à la base"
                    com.pause(false)
                    self.dismiss()
                }, endSnack: {
                    alertAdd = false
                })
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    func toEditMode(mot: Mot) {
        mode = .edition
        motEnCours = mot
        mots = motEnCours!.orthoAltNet
        def = motEnCours!.definition?.enonce ?? VIDE
        ba = motEnCours!.baseActive
        mm = motEnCours!.motMort
    }
    func toAddMode(ods: Ods9) {
        mode = .ajout
        odsEnCours = ods
        if networkMonitor.isConnected {
            let graphie = ods.graphie!
            ConsultElimots().getDef(mot: graphie) { elimot in
                // réponse périmée : l'utilisateur a continué à taper
                guard motRecherche.trimmingCharacters(in: .whitespaces) == graphie else { return }
                self.elimot = elimot
            }
        }
    }
    func toInvalidMode() {
        mode = .nonValide
        mots = VIDE
        def = VIDE
    }
    var enableCancelBtn: Bool {
        motRecherche.count > 0
    }
    var enableDelBtn: Bool {
        mode == .edition
    }
    var enableSaveNewBtn: Bool {
        mode == .ajout
    }
    var enableSaveEditBtn: Bool {
        mode == .edition && (ba != motEnCours?.baseActive || mm != motEnCours?.motMort || def != motEnCours?.definition?.enonce)
    }
    var enableSwitches: Bool {
        [.edition, .ajoutGraphie].contains(mode)
    }
}
