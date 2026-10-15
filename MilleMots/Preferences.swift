//
//  Preferences.swift
//  MilleMots
//
//  Created by Simon Wintz on 10/04/2024.
//


import Foundation
import SwiftUI

struct Preferences: View {
    @AppStorage(USER_SEQ_SUCC) var seqSucc : Int = DEFAULT_SEQ_SUCC
    @AppStorage(USER_nTirages) var nTirages : Int = DEFAULT_nTirages
    @AppStorage(USER_N_SUGG) var nSugg : Int = DEFAULT_N_SUGG
    @AppStorage(USER_RATIO_CONSO) var ratioConsolidations : Double = DEFAULT_RATIO_CONSO
    @AppStorage(USER_SHAREFILE_NAME) var shareFileName : String = DEFAULT_SHAREFILE_NAME
    @AppStorage(USER_20_20_RECORD) var record2020 : Int = DEFAULT_20_20_RECORD
    @EnvironmentObject var com : Com
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            VStack {
                Text("Préférences")
                    .frame(maxWidth: .infinity, alignment: .top)
                    .dynamicTypeSize(.xLarge)
                    .fontWeight(.bold)
                    .padding(20)
                List {
                    HStack {
                        Text("Séquence succès mini")
                        Spacer()
                        Text("\(seqSucc)")
                        Spacer()
                        VStack{
                            Button() {
                                seqSucc += 1
                            } label:{
                                Image("arrow_up")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.borderless)
                            Button() {
                                if seqSucc > 0 {
                                    seqSucc -= 1
                                }
                                
                            } label:{
                                Image("arrow_dwn")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowBackground(Color("fondbleu"))
                    HStack {
                        Text("Nombre de tirages part séquence")
                        Spacer()
                        Text("\(nTirages)")
                        Spacer()
                        VStack{
                            Button() {
                                nTirages += 1
                            } label:{
                                Image("arrow_up")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.borderless)
                            Button() {
                                if nTirages > nTirages_MINI {
                                    nTirages -= 1
                                }
                                
                            } label:{
                                Image("arrow_dwn")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowBackground(Color("fondbleu"))
                    HStack {
                        Text("Nombre de suggestions")
                        Spacer()
                        Text("\(nSugg)")
                        Text("mots")
                        Spacer()
                        VStack{
                            Button() {
                                nSugg += 1
                            } label:{
                                Image("arrow_up")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.borderless)
                            Button() {
                                if nSugg > 0 {
                                    nSugg -= 1
                                }
                                
                            } label:{
                                Image("arrow_dwn")
                                    .resizable(resizingMode: .stretch)
                                    .frame(width: BTN_SIZE, height: BTN_SIZE)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowBackground(Color("fondbleu"))
                    VStack {
                        Text("Préférence Consolidations")
                        Slider(value: $ratioConsolidations, in: 0...10, step: 1)
                        HStack {
                            Text("Mots Anciens")
                                .dynamicTypeSize(.xSmall)
                                .italic()
                            Spacer()
                            Text("Mots Difficiles")
                                .dynamicTypeSize(.xSmall)
                                .italic()
                        }
                    }
                    .listRowBackground(Color("fondbleu"))
                    HStack {
                        Text("Nom du fichier de partage")
                        Spacer()
                        TextField("", text: $shareFileName)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Chalkduster", size: 14))
                            .onChange(of: shareFileName) {
                                let count = shareFileName.count
                                if count > 0 && !ALLOWED_CAR_FILENAME.contains(shareFileName.last!) {
                                    shareFileName = String(shareFileName.dropLast())
                                }
                            }
                    }
                    .listRowBackground(Color("fondbleu"))
                    HStack {
                        Text(LocalizedStringKey("Meilleur temps 20/20"))
                        Spacer()
                        Text(durationToString(duration: record2020))
                        Spacer()
                        Button() {
                            record2020 = 0
                        } label:{
                            Image("reset")
                                .resizable(resizingMode: .stretch)
                                .frame(width: BTN_SIZE, height: BTN_SIZE)
                        }
                    }
                    .listRowBackground(Color("fondbleu"))
                }
                .listStyle(PlainListStyle())
                .background(Color("fondbleu"))
                .scrollContentBackground(.hidden)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                HStack {
                    Spacer()
                    Button() {
                        com.path = NavigationPath()
                    } label:{
                        Image("quitter")
                            .btnStyle()
                    }
                    Spacer()
                    Button() {
                        self.dismiss()
                    } label:{
                        Image("help")
                            .btnStyle()
                    }
                    Spacer()
                    NavigationLink(value: DataObject.init(name:"store")) {
                        Image("store")
                            .btnStyle()
                    }
                    Spacer()
                    NavigationLink(value: DataObject.init(name:"share")) {
                        Image("share")
                            .btnStyle()
                    }
                    Spacer()
                }
                .padding(20)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(DECALAGE_BORDURE)
        .background(Color("fondbleufonce"))
    }
}
