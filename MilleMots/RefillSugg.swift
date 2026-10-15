//
//  RefillSugg.swift
//  MilleMots
//
//  Created by Simon Wintz on 05/05/2024.
//

import Foundation
import SwiftUI
import CoreData

struct SuggItem: Identifiable {
    let id = UUID()
    let sug: Sugg
    let motsList: [String]
    var onGarde = true
    init(sug: Sugg) {
        self.sug = sug
        self.motsList = sug.mots!.components(separatedBy: " ").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    }
}

struct RefillSugg : View {
    
    @Binding var sugList : [SuggItem]
    @Binding var nTotSug : Int
    
    @AppStorage(USER_N_SUGG) var nSugg : Int = DEFAULT_N_SUGG
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Sugg.entity(), sortDescriptors: [NSSortDescriptor(key: "timeStamp", ascending: false)])
    private var sugs: FetchedResults<Sugg>
    
    var body: some View {
        ZStack {
            List(sugList.indices, id:\.self) { index in
                HStack {
                    CheckBox(isChecked: self.$sugList[index].onGarde)
                    Text("\(self.sugList[index].sug.mots!)")
                }
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
        .onAppear(){
            sugList = sugs.prefix(nSugg).map {SuggItem(sug: $0)}
            nTotSug = sugs.count
        }
    }
}
