//
//  Import.swift
//  MilleMots
//
//  Created by Simon Wintz on 01/05/2024.
//

import Foundation
import SwiftUI

struct Import: View {
    @State var listImport : [RefillItem]
    @State private var nVersBaseActive = 0
    @State private var nVersSugg = 0
    @State private var count = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Sugg.entity(), sortDescriptors: [NSSortDescriptor(key: "mots", ascending: false)])
    private var baseSuggs: FetchedResults<Sugg>
    
    var body: some View {
        VStack {
            Text("Repartition des imports")
            VStack {
                HStack () {
                    Spacer()
                    Image("exercice")
                        .resizable(resizingMode: .stretch)
                        .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    Text("\(nVersBaseActive)")
                        .dynamicTypeSize(.xxxLarge)
                    Spacer()
                    Text("\(nVersSugg)")
                        .dynamicTypeSize(.xxxLarge)
                    Image("essence")
                        .resizable(resizingMode: .stretch)
                        .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    Spacer()
                }
                HStack (spacing: 20) {

                    Button() {
                        nVersBaseActive = count
                        nVersSugg = 0
                    } label:{
                        Image("gauche_toutes")
                            .resizable(resizingMode: .stretch)
                            .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    }
                    Button() {
                        nVersBaseActive += 1
                        nVersSugg -= 1
                    } label:{
                        Image("fl_gauche")
                            .resizable(resizingMode: .stretch)
                            .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    }
                    Button() {
                        nVersBaseActive -= 1
                        nVersSugg += 1
                    } label:{
                        Image("fl_droite")
                            .resizable(resizingMode: .stretch)
                            .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    }
                    Button() {
                        nVersBaseActive = 0
                        nVersSugg = count
                    } label:{
                        Image("droite_toutes")
                            .resizable(resizingMode: .stretch)
                            .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
                    }
                }
            }
        }
        .onAppear() {
            let prfNSugg = UserDefaults.standard.integer(forKey: USER_N_SUGG)
            count = listImport.count
            nVersBaseActive = prfNSugg
            nVersSugg = count - prfNSugg
        }
    }
}
