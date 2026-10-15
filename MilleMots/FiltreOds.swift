//
//  OdsFiltreBackground.swift
//  MilleMots
//
//  Created by Simon Wintz on 26/11/2025.
//

import Foundation
import SwiftUI
import CoreData

struct FiltreOds: View {
    @Binding var odsAffiche: Ods9?
    @State var fetchCount: Int = 0
    @EnvironmentObject var com : Com
    @Environment(\.managedObjectContext) private var viewContext
    @State var ods: [Ods9] = []
    
    init(
        odsAffiche: Binding<Ods9?>,
    ) {
        self._odsAffiche = odsAffiche
    }
    
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
            }
        }
        .onChange(of: com.predicateOds, initial: true) {
            com.setTotalOds()
            Task(priority:.utility) {
                ods = await fetchData(context: viewContext, predicate: com.predicateOds)
                com.setTotalOds(ods.count)
            }
        }
    }
    
    private func fetchData(context: NSManagedObjectContext, predicate: NSPredicate) async -> [Ods9] {
        let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
        req.entity = Ods9.entity()
        req.sortDescriptors = [NSSortDescriptor(key: "graphie", ascending: true)]
        req.predicate = predicate
        req.fetchBatchSize = 10
        do {
            return try context.fetch(req)
        } catch {
            print("erreur fetch \(error)")
        }
        return []
    }
}

