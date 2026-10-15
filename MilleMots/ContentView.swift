//
//  ContentView.swift
//  MilleMots
//
//  Created by Simon Wintz on 28/02/2024.
//
import SwiftUI
import CoreData
import Foundation
import UIKit

struct ContentView: View {
    @State var odsAffiche: Ods9?
    @State var motPresse: Mot?
    @State var displayRecherche: Bool = false
    @State var displayOptions: Bool = false
    @State var motsImportesDeCarnaj: String?
    @EnvironmentObject var com: Com
    @AppStorage(FILTRE_L_MIN) var lMin: Int = LONGUEUR_MOT_MIN
    @AppStorage(FILTRE_L_MAX) var lMax: Int = LONGUEUR_MOT_MAX
    @AppStorage(BUG_AALENIEN) var bugAalenienFixed: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack(path: $com.path) {
            ZStack {
                VStack (spacing: 0) {
                    if odsAffiche != nil {
                        NavigationLink(destination: Edit(motRecherche: odsAffiche!.graphie ?? VIDE)) {
                            Group {
                                if odsAffiche!.mot != nil {
                                    VStack(spacing: 0) {
                                        DetailsMot(mot: odsAffiche?.mot)
                                        StatsMot(motAffiche: odsAffiche!.mot!)
                                    }
                                } else {
                                    DetailsMot(ods: odsAffiche!)
                                }
                            }
                            .overlay(alignment: .bottomTrailing) {
                                Button(CANCEL) {
                                    odsAffiche = nil
                                }
                                .dynamicTypeSize(.xSmall)
                                .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                .padding(.bottom, 24)
                                .padding(.trailing, DECALAGE_BORDURE)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            displayRecherche = false
                        })
                        Spacer(minLength: 8.0)
                    }
                    BtnLayout(displayRecherche: $displayRecherche, displayOptions: $displayOptions)
                        .disabled(com.displayKbd)
                    Filtres(odsAffiche: $odsAffiche, displayRecherche: $displayRecherche, displayOptions: $displayOptions, motPresse: $motPresse)
                    InfoBase(isGreen: com.displayOds)
                    Button(HOME) {
                        exit(0)
                    }
                }
                .padding(8)
                if com.message != "" {
                    Message()
                }
                motPresse != nil ? SnackBar(
                    message: motPresse!.refOds!.graphie!,
                    labelAction: motPresse!.baseActive ? String(localized: "DESACTIVER") : String(localized: "REACTIVER"),
                    isLong: false,
                    action: {
                        toggleStatusMot(context: viewContext, mot: motPresse!)
                    },
                    endSnack: {
                        motPresse = nil
                    }
                ) : nil
            }
            .navigationDestination(for: String.self) { mot in
                Edit(motRecherche: mot)
                    .id(mot)
            }
            .navigationDestination(for: DataObject.self) { course in
                switch course.name {
                case "dico": Edit(motRecherche: course.payload)
                case "reglages": Preferences()
                case "store": Store()
                case "share": ShareFile()
                case "help": Help()
                case "refill": Refill()
                case "interrogation": Interrogation()
                default: EmptyView()
                }
            }
            .background(Color("fondbleufonce").ignoresSafeArea())
            .onAppear() {
                com.largScreen = UIScreen.screenWidth
                odsAffiche = nil
                if !bugAalenienFixed {
                    fixBugAalenien()
                }
            }
            .onOpenURL { url in
                print("App was opened via URL: \(url)")
                handleIncomingURL(url)
            }
        }
        .accentColor(.black)
        .onAppear(perform: updateInfoBase)
        .onChange(of: com.isInterro) {
            if !com.isInterro {
                updateInfoBase()
            }
        }
    }
    private func updateInfoBase() {
        com.totalBase = totalBase(context: viewContext)
        com.totalCoups = totalCoups(context: viewContext)
        com.tauxSucces = tauxSucces(context: viewContext)
    }

    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "millemots" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        guard let mots = components.queryItems?.first(where: { $0.name == "mots"})?.value?.removeDiacritics() else {
            print("Mots à ajouter non trouvés")
            return
        }
        com.path = NavigationPath()
        com.path.append(mots.components(separatedBy: ",").first ?? "")
    }
    
    private func fixBugAalenien() {
        // Supprime l'AALENIEN importé avec un BOM (\u{FEFF}) en tête
        let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
        request.predicate = NSPredicate(format: "graphie ENDSWITH %@", "AALENIEN")
        if let items = try? viewContext.fetch(request) {
            for item in items where item.graphie?.unicodeScalars.first?.value == 0xFEFF {
                viewContext.delete(item)
            }
        }
        // Ajoute l'AALENIEN correct s'il manque
        if getOdsRef(context: viewContext, mot: "AALENIEN") == nil {
            let aalenien = Ods9(context: viewContext)
            aalenien.graphie = "AALENIEN"
            aalenien.spectre = "AAEEILNN"
            aalenien.nAna = 1
            aalenien.nonConjFemPlu = true
        }
        do {
            if viewContext.hasChanges { try viewContext.save() }
        } catch {
            print("fixBugAalenien : \(error)")
            viewContext.rollback()
            return
        }
        bugAalenienFixed = true
    }
}
