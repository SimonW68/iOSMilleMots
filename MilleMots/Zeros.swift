//
//  Zeros.swift
//  MilleMots
//
//  Created by Simon Wintz on 02/08/2024.
//

import Foundation
import SwiftUI

struct Zeros : View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Zero.entity(), sortDescriptors: [NSSortDescriptor(key: "antigraphie", ascending: true)])
    private var zeros: FetchedResults<Zero>
    @Environment(\.dismiss) var dismiss
    var body : some View {
        ZStack {
            ZStack {
                VStack {
                    Text("Zéros")
                        .frame(maxWidth: .infinity, alignment: .top)
                        .dynamicTypeSize(.xLarge)
                        .fontWeight(.bold)
                        .padding(20)
                    Spacer()
                        .frame(height: DECALAGE_BORDURE)
                    List() {
                        ForEach(zeros) { zero in
                            HStack {
                                Spacer()
                                Text("\u{1F479}")
                                    .dynamicTypeSize(.xxLarge)
                                Text(  zero.antigraphie ?? "Inconnu")
                                    .dynamicTypeSize(.large)
                                Text("\u{1F479}")
                                    .dynamicTypeSize(.xxLarge)
                                Spacer()
                            }
                            .listRowBackground(Color("fondrouge"))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewContext.delete(zeros[index])
                            }
                        }
                    }
                    .background(Color("fondrouge"))
                    .scrollContentBackground(.hidden)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .overlay(
                        RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                    
                HStack {
                    Spacer()
                    Button() {
                        self.dismiss()
                    } label:{
                        Image("quitter")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                    }
                    Spacer()
                }
                .padding(20)
                }

            }
            .navigationBarBackButtonHidden()
            .padding(DECALAGE_BORDURE)
        }
        .background(Color("fondrougefonce"))
    }
}

