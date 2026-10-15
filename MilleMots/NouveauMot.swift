//
//  NouveauMot.swift
//  MilleMots
//
//  Created by Simon Wintz on 11/03/2024.
//
import SwiftUI
import CoreData
import Foundation

enum Drapeau {
    case ok, doublon, identique, inconnu
}
enum FocusedField {
    case mots, definition
}

struct NouveauMot: View {
    @State var mots: String
    @State var def: String
    @State var motEnCours: String? = nil
    @State var motList : [String] = []
    @State var motAEditer: Mot? = nil
    @State var motZero: String = ""
    @State var color = Color.black
    @State var isMotsInvalide = false
    @State var bulleInfo = ""
    @State var alerteEditer : Bool = false
    @State var alerteInfo : Bool = false
    @State var alerteZero : Bool = false
    @State var displayDef : Bool = false
    @EnvironmentObject var com : Com
    @EnvironmentObject var del : Def
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @FocusState private var focusedField: FocusedField?
    @State private var drapeau = Drapeau.ok
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Nouveau Mot")
                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
                    
                    if focusedField == .mots {
                        Button() {
                            if drapeau == .doublon {
                                bulleInfo = String(localized: "Ce mot est déjà présent dans la base, voulez-vous l'éditer ?")
                                alerteEditer = true
                            } else if drapeau == .inconnu {
                                bulleInfo = String(localized: "Mot inconnu, voulez-vous l'ajouter à la liste des zéros ?")
                                motZero = mots
                                alerteZero = true
                            } else {
                                bulleInfo = String(localized: "Entrez les différentes graphies du mot, séparées par des espaces, exemple: QAT KAT KHAT")
                                alerteInfo = true
                            }
                            
                        } label:{
                            Image("help")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                    }
                    Spacer()
                    if drapeau == .ok && motEnCours != nil {
                        Button() {
                            if networkMonitor.isConnected {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil) //hide keyboard
                                displayDef = true
                            } else {
                                com.message = "Pas de connexion internet"
                            }

                        } label: {
                            Image("dico")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 50.0)
                
                VStack {
                    TextField("Mots", text:$mots, axis: .vertical)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxLarge/*@END_MENU_TOKEN@*/)
                        .padding()
                        .focused($focusedField, equals: .mots)
                        .foregroundColor(chooseColor(drapeau: drapeau))
                        .onChange(of: mots) { newValue, oldValue in
                            getMotEncours()
                            var motsAjoutes = [String]()
                            let count = mots.count
                            if count > 0 && !ALLOWED_CAR_NEW.contains(mots.last!) {
                                mots = String(mots.dropLast())
                            }
                            if mots.last == " " && drapeau != .ok {
                                mots = String(mots.dropLast())
                            }
                            if motEnCours != nil && motEnCours!.count > LONGUEUR_MOT_MAX {
                                mots = String(mots.dropLast())
                            }
                            for mot in motList {
                                if motsAjoutes.contains(mot) {
                                    drapeau = .identique
                                    isMotsInvalide = true
                                } else if let odsRef = getOdsRef(context: viewContext, mot: mot) {
                                    if odsRef.mot != nil {
                                        drapeau = .doublon
                                        isMotsInvalide = true
                                        def = odsRef.mot!.definition!.enonce!
                                        motAEditer = odsRef.mot
                                    } else {
                                        drapeau = .ok
                                        motsAjoutes.append(mot)
                                        isMotsInvalide = false
                                    }
                                } else {
                                    drapeau = .inconnu
                                    isMotsInvalide = true
                                }
                            }
                        }
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    TextField("Définition", text:$def, axis: .vertical)
                        .autocapitalization(.sentences)
                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                        .padding()
                        .focused($focusedField, equals: .definition)
                }
                .formatVue("fondbleu")
                ZStack {
                    HStack {
                        Spacer()
                        Button() {
                            addMots(context: viewContext, mots: mots, def: def)
                            let nm = mots.components(separatedBy: ESPACE).count
                            let s = nm > 1 ? "s" : ""
                            com.message = "\(nm) mot\(s) ajouté\(s) à la base"
                            self.dismiss()
                        } label:{
                            Image("ajouter")
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                        }
                        .disabled(def.isEmpty || isMotsInvalide)
                        .opacity((def.isEmpty || isMotsInvalide) ? 0.5 : 1)
                        Spacer()
                        Button() {
                            mots = ""
                            def = ""
                            focusedField = .mots
                        }label:{
                            Image("trash")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                        Spacer()
                        Button () {
                            self.dismiss()
                        } label: {
                            Image("cancel")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60.0)
                    
                    if displayDef {
                        DefEnLigne(displayDef: $displayDef, mot: motEnCours!)
                            .padding()
                    }
                }
            }
            .frame(
                minHeight: 0,
                alignment: .top
            )
            .padding(6)
            .background(Color("fondvert"))
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
            .overlay(
                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
            .onChange(of: del.utiliserDef) {
                if del.utiliserDef {
                    mots = del.mots
                    def = del.definition
                    focusedField = .definition
                    del.utiliserDef = false
                }
            }
            if alerteInfo {
                let labelAction = String(localized: "OK")
                SnackBar(message: bulleInfo,
                         labelAction: labelAction,
                         isLong: true,
                         action: {
                        },
                         endSnack: {
                            alerteInfo = false
                        })
            }
            if !com.message.isEmpty {
                Message()
            }
            if alerteZero {
                let labelAction = String(localized: "O K")
                SnackBar(message: bulleInfo, labelAction: labelAction, isLong: true, action: {
                    let newZero = Zero(context: viewContext)
                    newZero.antigraphie = motZero
                    saveContext(context: viewContext)
                    mots = ""
                    def = ""
                    focusedField = .mots
                    motZero = ""
                }, endSnack: {
                    alerteZero = false
                })
            }
        }
        .padding(6)
        .frame(
            minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color.white)
        .navigationBarBackButtonHidden()
        .safeAreaPadding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    private func getMotEncours() {
        motList = mots.trimmingCharacters(in: CharacterSet.whitespaces).split(separator: " ").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
        motEnCours = motList.last
    }
}
