//
//  QuickStart.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/06/2024.
//

import Foundation
import SwiftUI
import CoreData

struct QuickStart: View {
    @State private var showBackupFileImporter = false
    @State private var backupFileName = ""
    @State private var backupFileUrl = URL(filePath: "")
    @State var isLoading : Bool = false
    @State var alerteRestaure: Bool = false
    @AppStorage("sauter-aide") var skipHelp : Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
   
    var body: some View {
        ZStack {
            List {
                DataPolicy()
                    .formatElementHelp()
                
                InfoElimots()
                    .formatElementHelp()
                
                VStack {
                    Text("Si vous disposez d'une base précédemment sauvegardée, vous pouvez la recharger maintenant.")
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("Restaurer ma base : ")
                            .dynamicTypeSize(.xxLarge)
                            .fontWeight(.bold)
                        Button() {
                            showBackupFileImporter = true
                        } label:{
                            if !showBackupFileImporter {
                                Image("restaure")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: LARGE_BTN_SIZE, height: LARGE_BTN_SIZE)
                            } else {
                                ProgressView()
                            }
                        }
                        .fileImporter(
                            isPresented: $showBackupFileImporter,
                            allowedContentTypes: [.text],
                            allowsMultipleSelection: false) { result in
                                switch result {
                                case .success(let monFichier):
                                    let gotAccess = monFichier[0].startAccessingSecurityScopedResource()
                                    if !gotAccess {return}
                                    backupFileUrl = monFichier[0]
                                    backupFileName = monFichier[0].lastPathComponent
                                    alerteRestaure = true
                                case .failure(let error):
                                    print(error)
                                }
                            }
                    }
                    Text("Sinon lancez l'appli dans la section ci-dessous.")
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .formatElementHelp()
                
                VStack {
                    Text("Démarrage de MilleMots")
                        .fontWeight(.bold)
                        .dynamicTypeSize(.xxLarge)
                        .padding(.vertical, 20)

                    Text("Lancez le jeu par l'icône \("exercice".toText())")
                        .font(.body)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Replacez les lettres dans l'ordre et validez \("cible".toText(LARGE_BTN_SIZE))")
                        .font(.body)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: .zero) {
                        Text("K")
                            .formatTuile(tuileSize: 40)
                        Text("L")
                            .formatTuile(tuileSize: 40)
                        Spacer()
                            .frame(width:40)
                        Text("I")
                            .formatTuile(tuileSize: 40)
                        Text("X")
                            .formatTuile(tuileSize: 40)
                    }
                    .frame(height: 80)
                    .overlay(
                        ZStack {
                            Text("Y")
                                .formatTuile(tuileSize: 40)
                                .padding(.bottom, 30)
                                .padding(.trailing, 20)
                            Image("swipe")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.top, 20)
                                .padding(.leading, 10)
                        }
                        , alignment: .top)
                    
                    Text("Accéder à l'aide détaillée par l'icône \("settings".toText())")
                        .font(.body)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Spacer()
                        Text("Lancer MilleMots")
                            .dynamicTypeSize(.xxLarge)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button() {
                            isLoading = true
                            Task {
                                await loadSugg()
                                DispatchQueue.main.async {
                                    exit()
                                }
                            }
                        } label: {
                            Image("quick_start")
                                .resizable(resizingMode: .stretch)
                                .frame(width: LARGE_BTN_SIZE, height: LARGE_BTN_SIZE)
                        }
                        Text("maintenant")
                            .dynamicTypeSize(.xxLarge)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }
                }
                .formatElementHelp()
            }
            .navigationBarBackButtonHidden()
            .clipped()
            .listStyle(PlainListStyle())
            .listStyle(.grouped)
            .background(Color("fondbleufonce"))
            
            if alerteRestaure {
                if let dateCreation = backupFileUrl.creation {
                    let snackMessage = "Effectuer restauration de la base à partir du fichier\n\(backupFileName)\ncréé le \(dateCreation.formatted(date: .long, time: .shortened))."
                    let labelAction = String(localized: "C O N F I R M E R")
                    SnackBar(message: snackMessage, labelAction: labelAction, isLong: true, action: {
                        isLoading = true
                        Task {
                            await restoreData(url: backupFileUrl)
                            DispatchQueue.main.async {
                                backupFileUrl.stopAccessingSecurityScopedResource()
                                exit()
                            }
                        }
                    }, endSnack: {
                        alerteRestaure = false
                    })
                } else {
                    SnackBar(message: "Pas de sauvegarde trouvée", labelAction: "O K", isLong: false, action: {
                    }, endSnack: {
                        alerteRestaure = false
                    })
                }
            }
            if isLoading {
                LoadingView()
            }
        }
        .onAppear(perform: loadOds9)
    }
    
    private func restoreData(url: URL) async {
        print("Clearing data")
        clearAllMots(context: viewContext)
        print("Restoring data from backupfile file")
        if let imp = try? String(contentsOf: url, encoding: String.Encoding.utf8 ) {
            let impLines = imp.split(separator: "\r\n")
            for ligne in impLines {
                let indexPremierMot = ligne.firstIndex(of: " ")!
                let premierMot = String(ligne[..<indexPremierMot])
                if let sug = checkSugg(context: viewContext, mot: premierMot) {
                    viewContext.delete(sug)
                }
                let indexDef = ligne.firstIndex(of: ";")!
                let def = String(ligne[indexDef...].dropFirst(2))
                let definition = addDef(context: viewContext, def: def)
                let mots = String(ligne[..<indexDef]).split(separator: ",")
                for mot in mots {
                    let motAtts = mot.split(separator: " ")
                    if let refOds = getOdsRef(context: viewContext, mot: String(motAtts[INDEX_GRAPHIE])) {
                        if refOds.mot == nil {
                            let newMot = Mot(context: viewContext)
                            newMot.definition = definition
                            newMot.refOds = refOds
                            newMot.baseActive = String(motAtts[INDEX_BASE_ACTIVE]).boolValue
                            newMot.motMort = String(motAtts[INDEX_MOT_MORT]).boolValue
                            newMot.nChrono = Int32(motAtts[INDEX_NCHRONO])!
                            newMot.nEchec = Int16(motAtts[INDEX_NECHEC])!
                            newMot.nEssai = Int16(motAtts[INDEX_NESSAI])!
                            newMot.nSession = Int16(motAtts[INDEX_NSESSION])!
                            newMot.sqSucces = Int16(motAtts[INDEX_SQSUCCES])!
                        } else {
                            print("mot :\(mot) déja présent")
                        }
                    }  else {
                        print("mot :\(mot) non reconnu")
                    }
                }
            }
            saveContext(context: viewContext)
        }
    }
    
    func loadOds9() {
        print("Chargement ods9")
        guard let url = Bundle.main.url(forResource: "ods_mille_mots", withExtension: "txt") else {
            fatalError("ods9_mm.txt not found")
        }
        let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
        request.fetchLimit = 1
        let count = try? viewContext.count(for: request)
        guard  count == 0 else { return }
        if let ods9 = try? String(contentsOf: url, encoding: String.Encoding.utf8 ) {
            let ods9lignes = ods9.split(separator: "\r\n")
            for ligne in ods9lignes {
                let elements = ligne.split(separator: ";")
                let graphie = elements[0]
                let spectre = graphie.sorted()
                let nonConjFemPlu = (Int(elements[1]) == 1)
                let nAnagrammes = Int(elements[2])
                let ods9item = Ods9(context: viewContext)
                ods9item.graphie = String(graphie)
                ods9item.spectre = String(spectre)
                ods9item.nonConjFemPlu = nonConjFemPlu
                ods9item.nAna = Int16(nAnagrammes!)
            }
            do {
                try viewContext.save()
            } catch {
                print("Errort saving ods9: \(error)")
            }
        }
    }
    
    func loadSugg() async {
        print("Loading sugg")
        guard let url = Bundle.main.url(forResource: "Suggestions", withExtension: "txt") else {
            fatalError("Suggestions.txt not found")
        }
        if let sugg = try? String(contentsOf: url, encoding: String.Encoding.utf8 ) {
            let suggLines = sugg.split(separator: "\r\n")
            for sug in suggLines.dropFirst() {
                let index = sug.firstIndex(of: ";")!
                let mots = String(sug[..<index]).components(separatedBy: " ")
                let def = String(sug[index...].dropFirst(2))
                
                let definition = addDef(context: viewContext, def: def)
                for mot in mots {
                    if let refOds = getOdsRef(context: viewContext, mot: String(mot)) {
                        if refOds.mot == nil {
                            let newMot = Mot(context: viewContext)
                            newMot.definition = definition
                            newMot.refOds = refOds
                            newMot.baseActive = true
                            newMot.motMort = false
                            newMot.nChrono = .zero
                            newMot.nEchec = .zero
                            newMot.nEssai = .zero
                            newMot.nSession = .zero
                            newMot.sqSucces = .zero
                        } else {
                            print("mot :\(mot) déja présent")
                        }
                    }  else {
                        print("mot :\(mot) non reconnu")
                    }
                }
            }
            do {
                try viewContext.save()
            } catch {
                print("Errort saving sugg: \(error)")
            }
        }
    }
    private func exit() {
        skipHelp = true
        self.dismiss()
    }
}
