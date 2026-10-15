//
//  ShareFile.swift
//  MilleMots
//
//  Created by Simon Wintz on 12/04/2024.
//
import Foundation
import SwiftUI
import CoreData

let INDEX_GRAPHIE = 0
let INDEX_BASE_ACTIVE = 1
let INDEX_MOT_MORT = 2
let INDEX_NCHRONO = 3
let INDEX_NECHEC = 4
let INDEX_NESSAI = 5
let INDEX_NSESSION = 6
let INDEX_SQSUCCES = 7

struct ShareFile : View {
    @State private var graphies = [String]()
    @State private var showImportFileImporter = false
    @State private var listImport = [ImportItem]()
    @State private var importFileName = ""
    @State private var nLus = 0
    @State var isLoading : Bool = false
    @EnvironmentObject var com : Com
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Mot.entity(), sortDescriptors: [NSSortDescriptor(key: "refOds.graphie", ascending: false)])
    private var mots: FetchedResults<Mot>
    @Environment(\.dismiss) var dismiss

    var body : some View {
        ZStack {
            ZStack {
                VStack {
                    if !showImportFileImporter {
                        Backup()
                            .padding(15)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .overlay(
                                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))


                        Export()
                            .padding(15)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .overlay(
                                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                    }
                    VStack {
                        HStack {
                            Text("Importer : ")
                                .dynamicTypeSize(.xxLarge)
                                .fontWeight(.bold)
                            Button() {
                                showImportFileImporter = true
                            } label:{
                                Image("_import")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .fileImporter(
                                isPresented: $showImportFileImporter,
                                allowedContentTypes: [.text],
                                allowsMultipleSelection: false) { result in
                                    switch result {
                                    case .success(let monFichier):
                                        let gotAccess = monFichier[0].startAccessingSecurityScopedResource()
                                        if !gotAccess {return}
                                        importFileName = monFichier[0].lastPathComponent
                                        isLoading = true
                                        Task {
                                            nLus = await importData(url: monFichier[0])
                                            DispatchQueue.main.async {
                                                monFichier[0].stopAccessingSecurityScopedResource()
                                                isLoading = false
                                            }
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                        }
                        if !listImport.isEmpty {
                            Text(importFileName)
                                .font(.custom("Chalkduster", size: 14))
                            HStack {
                                Spacer()
                                Text("Lus : \(nLus)")
                                Spacer()
                                Text("Nouveaux : \(listImport.count)")
                                Spacer()
                            }
                            .padding()
                            List(listImport.indices, id:\.self) { index in
                                Text("\(self.listImport[index].mots)")
                                    .frame(height:15)
                                    .listRowBackground(Color("fondbleu"))
                                    .listRowSeparator(.hidden)
                            }
                            .environment(\.defaultMinListRowHeight, 15)
                            .listStyle(PlainListStyle())
                            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .top)
                            .background(Color("fondbleu"))
                            .scrollContentBackground(.hidden)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .overlay(
                                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                        
                        }
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color("fondbleu"))
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .overlay(
                        RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                    
                    Spacer()
                    
                    HStack (spacing: 20) {
                        Button() {
                            self.dismiss()
                        } label:{
                            Image("quitter")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                        if !listImport.isEmpty {
                            Button() {
                                let count = addImportToSugg(context: viewContext, listImport: listImport)
                                com.message = "\(count) nouvelles suggestions ajoutées"
                                listImport.removeAll()
                                
                            } label:{
                                Image("save")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                        }
                    }
                    .padding(15)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color("fondbleu"))
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .overlay(
                        RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                }
                if isLoading {
                    VStack {
                        Text("Chargement des données...")
                        ProgressView()
                    }
                }
                if com.message != "" {
                    Message()
                }
            }
            .padding(DECALAGE_BORDURE)
            .navigationBarBackButtonHidden()
            .onAppear {
                graphies = mots.map {
                    $0.refOds!.graphie!
                }
            }
        }
        .background(Color("fondbleufonce"))
    }
    
    private func motsAlreadyInBaseMot(motsList: [String]) -> Bool {
        
        for graphie in motsList {
            if graphies.contains(graphie) {
                return true
            }
        }
        return false
    }
    
    private func importData(url: URL) async -> Int {
        print("Loading data from share file")
        
        if let imp = try? String(contentsOf: url, encoding: String.Encoding.utf8 ) {
            
            let impLines = imp.split(separator: "\r\n")
            
            if impLines[0] != ENTETE_SHAREFILE {
                com.message = String(localized: "Fichier d'échange non reconnu")
            } else {
                for item in impLines.dropFirst() {
                    let importLigne = ImportLigne(context: viewContext, item: item)
                    let mots = importLigne.mots
                    let motsList = importLigne.motsList
                    let def = importLigne.def
                    
                    if !motsList.isEmpty && !motsAlreadyInBaseMot(motsList: motsList) {
                        listImport.append(ImportItem(mots:mots, def:def))
                    } else {
                        print("\(mots) \(def) déjà dans la base ou inconnu")
                    }
                }
                let nMotsNouveaux = listImport.count
                if nMotsNouveaux == 0 {
                    com.message = String(localized: "Aucun mot nouveau trouvé dans le fichier")
                }
            }
            return impLines.count - 1
        } else {
            return 0
        }
    }
}

struct ImportLigne {
    let mots: String
    let motsList: [String]
    let def: String
    init (context: NSManagedObjectContext, item: String.SubSequence) {
        let index = item.firstIndex(of: ",")!
        self.mots = String(item[..<index])
        self.motsList = sontDansOds(context: context, mots:mots.components(separatedBy: " "))
        self.def = String(item[index...].dropFirst(2))
    }
}

extension String {
var boolValue: Bool {
    return (self as NSString).boolValue
}}

extension URL {
    var creation: Date? {
        get {
            return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.creationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
