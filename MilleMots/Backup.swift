//
//  Backup.swift
//  MilleMots
//
//  Created by Simon Wintz on 11/12/2024.
//

import Foundation
import SwiftUI


struct Backup: View {
    @State private var url : URL?
    @AppStorage("date-sauvegarde") var dateSauvegarde : Double?
    @State var tempDate : Date?
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Definition.entity(), sortDescriptors: [])
    private var motsEtDef: FetchedResults<Definition>
    
    var body : some View {
        VStack {
            HStack {
                Text("Sauvegarder : ")
                    .dynamicTypeSize(.xxLarge)
                    .fontWeight(.bold)
                if url != nil {
                    ShareLink(item: url!, subject: Text(BACKUPFILE_NAME)) {
                        Image("backup")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        tempDate = Date.now
                    })
                }
            }
            if dateSauvegarde != nil {
                Text("Dernière en date du : \(Date(timeIntervalSinceReferenceDate: dateSauvegarde!).formatted(date: .long, time: .shortened))")
            }
        }
        .onAppear(perform: transfDataToFile)
        .onDisappear() {
            if tempDate != nil {
                dateSauvegarde = tempDate!.timeIntervalSinceReferenceDate
            }
        }
    }
    
    private func transfDataToFile() {
        url = URL.documentsDirectory.appending(path: BACKUPFILE_NAME)
        var outStr = ""
        motsEtDef.forEach { (def: Definition) in
            let entiteMotList = def.graphies as! Set<Mot>
            let motsList = entiteMotList.map {"\($0.refOds!.graphie!) \($0.baseActive) \($0.motMort) \($0.nChrono) \($0.nEchec) \($0.nEssai) \($0.nSession) \($0.sqSucces)"}
            let mots = motsList.joined(separator: ",")
            if !mots.isEmpty {
                let newLine = "\(mots); \(def.enonce!)\r\n"
                outStr.append(newLine)
            } else {
                viewContext.delete(def)
            }
        }
        
        let data = Data(outStr.utf8)
        do {
            try data.write(to: url!, options:[.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
}
