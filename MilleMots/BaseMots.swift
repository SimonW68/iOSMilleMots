//
//  BaseMots.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/01/2025.
//
/*
 import Foundation
 import SwiftUI
 import CoreData
 
 struct BaseMots : View {
 var predicate: NSPredicate
 var sortDescriptors: [NSSortDescriptor]
 @Binding var motAffiche: Mot?
 @Binding var motPresse: Mot?
 @Binding var alerteToggle: Bool
 @Binding var btnUpPressed: Bool
 @Binding var btnDwnPressed: Bool
 @State var seuilNErr: Int = 0
 @State var currentRowIndex : Int = 1
 @FetchRequest private var mots: FetchedResults<Mot>
 @EnvironmentObject var jeu: JeuSet
 @AppStorage(USER_N_TIRAGES) var nTirages : Int = DEFAULT_N_TIRAGES
 @AppStorage(USER_OPTION_PROCHES) var optionProches : Bool = DEFAULT_OPTION_PROCHES
 
 init(
 predicate: NSPredicate,
 sortDescriptors: [NSSortDescriptor],
 motAffiche: Binding<Mot?>,
 motPresse: Binding<Mot?>,
 alerteToggle: Binding<Bool>,
 btnUpPressed: Binding<Bool>,
 btnDwnPressed: Binding<Bool>
 ) {
 self.predicate = predicate
 self.sortDescriptors = sortDescriptors
 self._motAffiche = motAffiche
 self._motPresse = motPresse
 self._alerteToggle = alerteToggle
 self._btnUpPressed = btnUpPressed
 self._btnDwnPressed = btnDwnPressed
 self.seuilNErr = 0
 self.currentRowIndex = 1
 _mots = FetchRequest<Mot>(sortDescriptors: sortDescriptors, predicate: predicate)
 }
 
 @Environment(\.managedObjectContext) private var viewContext
 
 var body: some View {
 ZStack {
 ScrollViewReader { proxy in
 let motsCount = mots.count
 let scrollPitch = motsCount / N_SCROLLS
 List {
 ForEach(mots.indices.reversed(), id: \.self) { index in
 let mot = mots[index]
 let font =
 if mot.baseActive { FONT_ACTIF }
 else if mot.motMort { FONT_ACQUIS }
 else { FONT_INACTIF }
 
 HStack {
 let dotColor = if mot.nEchec > seuilNErr { Color.red } else if mot.nEchec > 0 { Color.orange } else { Color.green }
 Circle()
 .strokeBorder(.black, lineWidth: 1)
 .fill(dotColor)
 .frame(width: 8, height: 8)
 Text(mot.refOds!.graphie ?? "")
 .font(font)
 .onAppear{
 currentRowIndex = index
 }
 Spacer()
 }
 .id(index)
 .padding(.horizontal, 20)
 .frame(height: 10)
 .onTapGesture {
 motAffiche = mot
 }
 .onLongPressGesture(minimumDuration: 0.2){
 motPresse = mot
 alerteToggle = true
 }
 }
 .listRowBackground(Color("fondbleu"))
 .listRowSeparator(.hidden)
 }
 .environment(\.defaultMinListRowHeight, 10)
 .listStyle(PlainListStyle())
 .scrollContentBackground(.hidden)
 .onChange (of: btnUpPressed) {
 let scrollTarget = min(currentRowIndex + scrollPitch, motsCount )
 withAnimation {
 proxy.scrollTo(scrollTarget)
 }
 }
 .onChange (of: btnDwnPressed) {
 let scrollTarget = max(currentRowIndex - scrollPitch, 0 )
 withAnimation {
 proxy.scrollTo(scrollTarget)
 }
 }
 }
 }
 .onAppear {
 if !mots.isEmpty {
 seuilNErr = Int(mots[mots.count/FRACTION_ROUGE].nEchec)
 }
 }
 }
 }
 */
