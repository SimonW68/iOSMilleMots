//
//  Filtres.swift
//  MilleMots
//
//  Created by Simon Wintz on 22/07/2024.
//

import Foundation
import SwiftUI
import CoreData

struct Filtres : View {
    @Binding var odsAffiche: Ods9?
    @Binding var displayRecherche: Bool
    @Binding var displayOptions: Bool
    @Binding var motPresse: Mot?
    @State var displayOutilFiltre : Bool = false
    @State var sortDescriptors : [NSSortDescriptor] = [NSSortDescriptor(key: "refOds.graphie", ascending: false)]
    @AppStorage(USER_ORDER_TRI_BASE_MOTS) var ordreTri : OrdreTri = .alpha
    @EnvironmentObject var com : Com
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    var body : some View {
        VStack(spacing: DECALAGE_BORDURE) {
            if !displayOutilFiltre {
                HStack(alignment: .top) {
                    Spacer()
                    VStack {
                        Text(com.descriptionFiltre()[0]) + Text(com.descriptionFiltre()[1]).foregroundColor(com.displayOds ? Color("vert") : .black)
                        Text(com.descriptionFiltre()[2])
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                .padding(3)
                .dynamicTypeSize(.xLarge)
                .formatVue("fondbleu")
                .onTapGesture {
                    odsAffiche = nil
                    displayOutilFiltre.toggle()
                }
            } else {
                OutilFiltre(displaySelf: $displayOutilFiltre)
                .formatVue()
                .overlay(!com.displayKbd ?
                    Button(CANCEL) {
                        displayOutilFiltre.toggle()
                    }
                    .dynamicTypeSize(.xSmall)
                    .padding(.bottom, 8)
                    .padding(.trailing, 8)
                         : nil, alignment: .bottomTrailing)
            }
            HStack {
                Carrousel(
                    odsAffiche: $odsAffiche,
                    motPresse: $motPresse,
                    sortDescriptors: sortDescriptors,
                )
                VStack(spacing: 50) {
                    Button() {
                        ordreTri = ordreTri.next
                        sortDescriptors = ordreTri.sortDescriptor
                    } label: {
                        IconeTri(ordreTri: ordreTri)
                    }
                    .disabled(com.displayOds)
                    Group {
                        if com.actifsOnly {
                            Text("\(com.totalFiltre)")
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundColor(Color("fondbleu"))
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.5))
                                        .frame(width: PASTILLE_COUNT_SIZE, height: PASTILLE_COUNT_SIZE)
                                )
                        } else {
                            Text("\(com.totalFiltre)")
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .stroke(.black, lineWidth: 2)
                                        .frame(width: PASTILLE_COUNT_SIZE, height: PASTILLE_COUNT_SIZE)
                                )
                        }
                    }
                    .onTapGesture {
                        if com.displayOds {
                            com.displayOds.toggle()
                        } else {
                            com.actifsOnly.toggle()
                            com.applyFilter()
                        }
                    }
                    
                    if !com.requeteVide {
                        Circle()
                            .fill(Color("vert").opacity(com.totalOds == 0 ? 0.3 : 1))
                            .frame(width:PASTILLE_COUNT_SIZE, height:PASTILLE_COUNT_SIZE)
                            .overlay(
                                Button("\(com.totalOds)") {
                                    com.displayOds.toggle()
                                }
                                    .font(.caption)
                                    .lineLimit(1)
                                    .foregroundColor(Color("fondbleu"))
                                    .disabled(com.totalOds == 0)
                            )
                    }
                    // permet d'exporter la requète en cours dans un fichier texte (cf. struct MotsFiltres)
                     //if com.url != nil {
                     //ShareLink(item: com.url!, subject: Text("MaListeDeMots.txt")) {
                     //Image("save")
                     //.resizable(resizingMode: .stretch)
                     //.frame(width: BTN_SIZE, height: BTN_SIZE)
                     //}
                     //} else {
                     //Button() {
                     //com.saveFile.toggle()
                     //} label : {
                     //Image("export")
                     //.resizable()
                     //.  frame(width: BTN_SIZE, height: BTN_SIZE)
                     //}
                     //}
                    Spacer()
                }
                .padding(.horizontal, 6)
                .background(Color("fondbleu"))
                .frame(width: PASTILLE_COUNT_SIZE)
            }
            .formatVue("fondbleu")
            .overlay(com.isLoadingOds ?
                     LoadingView(opacity: 0.5).cornerRadius(12.0)
                     : nil)
        }
        .overlay(displayOptions ?
                 Options(displayOption: $displayOptions)
            .padding()
                 : nil)
        .onAppear(perform: com.applyFilter)
    }
}






