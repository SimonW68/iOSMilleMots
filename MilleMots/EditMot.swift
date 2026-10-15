//
//  EditMot.swift
//  MilleMots
//
//  Created by Simon Wintz on 12/04/2024.
//

import Foundation
import SwiftUI
import CoreData

struct EditMot : View {

    @State var ods: Ods9?
    @State var orthoAlt : String = ""
    @State var newGraphieSelectionne : Bool = false
    @State var newGraphie : String = ""
    @State var editDefSelectionne : Bool = false
    @State var newDefinition : String = ""
    @State var drapeau : Drapeau = .ok
    @State var baseActive : Bool = true
    @State var motMort : Bool = false
    @State var displayDef : Bool = false
    @State var dummyMots : String = ""
    @EnvironmentObject var com : Com
    @EnvironmentObject var del : Def
    @FocusState private var focusedField: FocusedField?
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    Text("Editer un mot:")
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(10)
                        .dynamicTypeSize(.xLarge)
                        .fontWeight(.bold)
                    
                    if ods != nil {
                        VStack {
                            HStack {
                                Text("\(ods!.graphie!)")
                                    .dynamicTypeSize(.xxLarge)
                                    .fontWeight(.bold)
                                Text("\(orthoAlt)")
                                    .dynamicTypeSize(.xLarge)
                            }
                            Text("\(ods!.mot!.definition!.enonce!)")
                                .dynamicTypeSize(.small)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        .cornerRadius(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                        
                        HStack {
                            Toggle(String(localized: "Actif :"), isOn: $baseActive)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                .onChange(of: baseActive) {
                                    if baseActive {
                                        motMort = false
                                    }
                                }
                            Spacer()
                                .frame(width: 2 * BTN_SIZE)
                            
                            Toggle(String(localized: "Acquis :"), isOn: $motMort)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                .onChange(of: motMort) {
                                    if motMort {
                                        baseActive = false
                                    }
                                }
                        }
                    }
                    
                    VStack {
                        Toggle(String(localized: "Ajouter une graphie :"), isOn: self.$newGraphieSelectionne)
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            .onChange(of: newGraphieSelectionne) {
                                if newGraphieSelectionne {
                                    focusedField = .mots
                                }
                            }
                        if newGraphieSelectionne {
                            TextField(String(localized: "Nouvelle graphie"), text: $newGraphie)
                                .focused($focusedField, equals: .mots)
                                .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                                .autocorrectionDisabled()
                                .dynamicTypeSize(.xxLarge)
                                .fontWeight(.bold)
                                .onChange (of: newGraphie) {
                                    
                                    let count = newGraphie.count
                                    if count > 0 && !ALLOWED_CAR_EDIT.contains(newGraphie.last!) {
                                        newGraphie = String(newGraphie.dropLast())
                                    }
                                    if count > LONGUEUR_MOT_MAX {
                                        newGraphie = String(newGraphie.dropLast())
                                    } else if count > 2 {
                                        if let refOds = getOdsRef(context: viewContext, mot: newGraphie) {
                                            drapeau = refOds.mot != nil ? .doublon : .ok
                                        } else if newGraphie == ods!.graphie || orthoAlt.contains(newGraphie) {
                                            drapeau = .doublon
                                        } else {
                                            drapeau = .inconnu
                                        }
                                    }
                                }
                                .foregroundColor(chooseColor(drapeau: drapeau))
                        }
                        HStack {
                            Toggle(String(localized: "Editer la définition :"), isOn: self.$editDefSelectionne)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                .onChange(of: editDefSelectionne) {
                                    if editDefSelectionne {
                                        focusedField = .definition
                                    }
                                }
                            Button() {
                                displayDef = true
                            } label : {
                                Image("dico")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                        }
                        if editDefSelectionne {
                            TextField(String(localized: "Nouvelle définition"), text: $newDefinition)
                                .autocapitalization(.sentences)
                                .focused($focusedField, equals: .definition)
                                .dynamicTypeSize(.large)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                    ZStack {
                        HStack {
                            Spacer()
                            Button() {
                                let mot = ods!.mot
                                if mot != nil {
                                    if newGraphieSelectionne && newGraphie.count > 2 {
                                        if let refOds = getOdsRef(context: viewContext, mot: newGraphie) {
                                            print("refOds : \(refOds) \(refOds.graphie!)")
                                            let newMot = Mot(context: viewContext)
                                            newMot.definition = mot!.definition
                                            newMot.refOds = refOds
                                        }
                                    } else if baseActive != mot!.baseActive || motMort != mot!.motMort {
                                        let motUpdate = mot! as NSManagedObject
                                        if baseActive {
                                            motUpdate.setValue(0, forKey: "sqSucces")
                                            motUpdate.setValue(mot!.nSession + 1, forKey: "nSession")
                                        }
                                        motUpdate.setValue(baseActive, forKey: "baseActive")
                                        motUpdate.setValue(motMort, forKey: "motMort")
                                    } else if editDefSelectionne || newDefinition != "" {
                                        let defUpdtae = mot!.definition! as NSManagedObject
                                        defUpdtae.setValue(newDefinition, forKey: "enonce")
                                    }
                                    saveContext(context: viewContext)
                                }
                                ods = nil
                                self.dismiss()
                            } label:{
                                Image("save")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .disabled(newGraphieSelectionne && drapeau != .ok)
                            Spacer()
                            Button() {
                                ods = nil
                                self.dismiss()
                            } label:{
                                Image("cancel")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            Spacer()
                            
                        }
                        .padding(10)
                        
                        if displayDef {
                            DefEnLigne(displayDef: $displayDef,mot: ods!.graphie!)
                                .padding()
                        }
                    }
                }
                .onChange(of: del.utiliserDef) {
                    if del.utiliserDef {
                        editDefSelectionne = true
                        newDefinition = del.definition
                        del.utiliserDef = false
                    }
                }
                if com.message != "" {
                    Message()
                }
            }
            .navigationBarBackButtonHidden()
            .padding(DECALAGE_BORDURE)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("fondbleufonce"))
        .onAppear() {
            let mot = ods!.mot
            if mot != nil {
                orthoAlt = mot!.orthoAlt
                baseActive = mot!.baseActive
                motMort = mot!.motMort
                newDefinition = mot!.definition!.enonce!
            }
        }
    }
}


