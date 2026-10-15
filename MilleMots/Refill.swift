//
//  Refill.swift
//  MilleMots
//
//  Created by Simon Wintz on 09/04/2024.
//

import Foundation
import CoreData
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content:View>(_ condition:Bool, transform: (Self)-> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct Refill: View {
    
    @State var sugList = [SuggItem]()
    @State var revList = [RevItem]()
    @State var isDisplayRev = false
    @State var nTotSug = 0
    @State var nTotRev = 0
    @State var alerteRefill : Bool = false
    @State var refreshView : Bool = true
    @EnvironmentObject var com : Com
    @AppStorage(USER_N_SUGG) var nSugg : Int = DEFAULT_N_SUGG

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    HStack {
                        VStack {
                            Button(String(localized: "Consolidations")){
                                isDisplayRev = true
                                refreshView.toggle()
                            }
                            .dynamicTypeSize(.xLarge)
                            .fontWeight(.bold)
                            
                            if(isDisplayRev) {
                                Text("(\(nSugg)/\(nTotRev))")
                                    .dynamicTypeSize(.small)
                            }
                        }
                        .if(isDisplayRev) { view in
                            view.padding(10)
                                .background(Color("fondvert"))
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                .cornerRadius(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                        }
                        VStack {
                            Button(String(localized: "Importations")){
                                isDisplayRev = false
                                refreshView.toggle()
                            }
                                .dynamicTypeSize(.xLarge)
                                .fontWeight(.bold)
                            
                            if(!isDisplayRev) {
                                Text("(\(nSugg)/\(nTotSug))")
                                    .dynamicTypeSize(.small)
                            }

                        }
                        .if(!isDisplayRev) { view in
                            view.padding(10)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                .cornerRadius(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                        }
                    }
                    
                    if isDisplayRev{
                        RefillRev(revList: $revList, nTotRev: $nTotRev)
                            .id(refreshView)
                    } else {
                        RefillSugg(sugList: $sugList, nTotSug: $nTotSug)
                            .id(!refreshView)
                    }

                    HStack {
                        Spacer()
                        Button() {
                            alerteRefill = true
                        } label:{
                            Image("ajouter")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                        Spacer()
                        Button() {
                            self.dismiss()
                        } label:{
                            Image("cancel")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                        Spacer()
                    }
                }
                .padding(DECALAGE_BORDURE)
                .background(Color("fondbleu"))
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                
                VStack {
                    if com.message != "" {
                        Message()
                    }
                    
                    if alerteRefill {
                        let messageRefill = isDisplayRev ? String(localized: "\(nSugg) mots") : String(localized: "\(nSugg) importations")
                        let labelAction = isDisplayRev ? String(localized: "R E A C T I V E R") : String(localized: "A J O U T E R")

                        SnackBar(message: messageRefill, labelAction: labelAction, isLong: false, action: {
                            alerteRefill = false
                            if isDisplayRev {
                                let count = reactiveMots(context: viewContext, listMots: revList)
                                revList.removeAll()
                                com.message = "\(count) \(String(localized: "mots réactivés"))"
                            } else {
                                let count = transfSugToMot(context: viewContext, sugList: sugList)
                                sugList.removeAll()
                                com.message = "\(count) \(String(localized: "mots ajoutés à la base"))"
                            }
                            refreshView.toggle()
                        }, endSnack: {
                            alerteRefill = false
                        })
                    }
                }
            }
            .padding(DECALAGE_BORDURE)
            .navigationBarBackButtonHidden()
        }
        .background(Color("fondbleufonce").ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
