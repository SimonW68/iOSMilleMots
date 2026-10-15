//
//  RefillConso.swift
//  MilleMots
//
//  Created by Simon Wintz on 06/05/2024.
//

import Foundation
import SwiftUI
import CoreData

struct RevItem: Identifiable {
    let id = UUID()
    let mot: Mot
    var onGarde = true
    init(mot: Mot) {
        self.mot = mot
    }
}

struct RefillRev : View {
    
    @Binding var revList : [RevItem]
    @Binding var nTotRev : Int
    
    @AppStorage(USER_N_SUGG) var nSugg : Int = DEFAULT_N_SUGG
    @AppStorage(USER_RATIO_CONSO) var ratioConsolidations : Double = DEFAULT_RATIO_CONSO
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Mot.entity(), sortDescriptors: [NSSortDescriptor(key: "nChrono", ascending: true)], predicate: NSPredicate(format:"baseActive == %@ AND motMort == %@", false as NSNumber, false as NSNumber))
    private var mots: FetchedResults<Mot>
    
    var body: some View {
        ZStack {
            List(revList.indices, id:\.self) { index in
                HStack {
                    CheckBox(isChecked: self.$revList[index].onGarde)
                    Text("\(self.revList[index].mot.refOds!.graphie!)")
                }
                .frame(height:15)
                .listRowBackground(Color("fondvert"))
                .listRowSeparator(.hidden)
            }
            .environment(\.defaultMinListRowHeight, 15)
            .listStyle(PlainListStyle())
            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .top)
            .background(Color("fondvert"))
            .scrollContentBackground(.hidden)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
            .overlay(
                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
        }
        .onAppear(){
            nTotRev = mots.count
            let nTri = nTotRev * Int(ratioConsolidations) / 10
            revList = mots.prefix(nTri == 0 ? nSugg : nTri).sorted { ($0.nEchec, $0.nEssai) > ($1.nEchec, $1.nEssai) }.prefix(nSugg).map { RevItem(mot: $0)}
        }
    }
}
