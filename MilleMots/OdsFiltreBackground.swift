//
//  OdsFiltreBackground.swift
//  MilleMots
//
//  Created by Simon Wintz on 26/11/2025.
//

import Foundation
import SwiftUI
import CoreData

struct FiltreOdsBackg: View {
    @Binding var odsAffiche: Ods9?
    var predicate: NSPredicate
    @State var ods: [Ods9] = []
    @EnvironmentObject var com : Com
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns:[GridItem(.adaptive(minimum: LONG_MOT_9L))], alignment: .leading) {
                ForEach(ods, id:\.self) { ods in
                    HStack {
                        Text(ods.graphie ?? "")
                            .dynamicTypeSize(.xLarge)
                            .bold()
                            .foregroundColor(Color("vert"))
                        Spacer()
                    }
                    .padding(6)
                    .onTapGesture {
                        odsAffiche = ods
                    }
                }
                .onChange(of: com.getMotsAtrouver, initial: false) {
                    Task {
                        ods = await fetchData(context: viewContext, predicate: predicate)
                    }
                }
                .frame(maxWidth: 500)
            }
            
        }
    }
    
    func fetchData(context: NSManagedObjectContext, predicate: NSPredicate) async -> [Ods9] {
        let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
        req.entity = Ods9.entity()
        req.sortDescriptors = [NSSortDescriptor(key: "graphie", ascending: true)]
        req.predicate = predicate
        
        do {
            com.odsFiltreCount = try! context.count(for: req)
            return try context.fetch(req)
        } catch {
            print("erreur fetch \(error)")
        }
        return []
    }
}
