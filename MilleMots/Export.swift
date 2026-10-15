//
//  Export.swift
//  MilleMots
//
//  Created by Simon Wintz on 02/05/2024.
//

import Foundation
import SwiftUI

struct Export: View {
    @State private var url : URL?
    @AppStorage(USER_SHAREFILE_NAME) var shareFileName : String = DEFAULT_SHAREFILE_NAME
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Definition.entity(), sortDescriptors: [])
    private var motsEtDef: FetchedResults<Definition>
    
    var body : some View {
        HStack {
            Text("Exporter : ")
                .dynamicTypeSize(.xxLarge)
                .fontWeight(.bold)
            if url != nil {
                ShareLink(item: url!, subject: Text(shareFileName), message: Text("Veuillez-trouver ci-joint ma base de mots MilleMots.")) {
                    Image("export")
                        .resizable(resizingMode: .stretch)
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
            }
        }
        .onAppear(perform: transfDataToFile)
    }
    
    private func transfDataToFile() {
        url = URL.documentsDirectory.appending(path: shareFileName)
        var outStr = ""
        outStr.append("\(ENTETE_SHAREFILE)\r\n")
        motsEtDef.forEach { (def: Definition) in
            let entiteMotList = def.graphies as! Set<Mot>
            let motsList = entiteMotList.map {$0.refOds!.graphie!}
            let mots = motsList.joined(separator: " ")
            if !mots.isEmpty {
                let newLine = "\(mots), \(def.enonce!)\r\n"
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
