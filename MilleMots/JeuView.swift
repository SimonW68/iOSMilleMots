//
//  Reglette.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/04/2024.
//
import Foundation
import SwiftUI

struct JeuView : View {
    @Binding var motAffiche : Mot?
    @Binding var isUserPresent : Bool
    @State var reg: String = ""
    @State var startDate : Date = Date.now
    @State var cligno : Bool = false
    @State var btnValidDisabled : Bool = false
    @EnvironmentObject var com : Com
    
    let timer = Timer.publish(every: TIMER_INTERVAL, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if com.grandEcran || motAffiche == nil {
                Theme()
                    .padding(DECALAGE_BORDURE)
            }
            Spacer()
            if !com.essais.isEmpty {
                Text("Ana.: \(com.essais.joined(separator: ", "))")
            }
            Spacer().frame(height: 20)
            ZStack {
                ChronoTimer(progress: com.progress, cligno: cligno)
                    .frame(width:2 * SMALL_BTN_SIZE, height:2 * SMALL_BTN_SIZE)
                    .opacity(com.phase == .ordi ? 0 : 1 )
                Text("\(com.numeroCoup)")
                    .dynamicTypeSize(.xLarge)
                    .bold()
                    .opacity(com.phase == .ordi ? 0 : 1 )
            }
            Text(String(com.motAtrouver!.tirage.last ?? " "))
                .formatTuile(tuileSize: com.pasLettre - EP_FILET)
                .opacity(com.showPlusUn ? 1 : 0)
                .blur(radius: com.isPause ? BLUR_RADIUS : 0)
                .padding(.vertical, com.pasLettre / 2)
                .onTapGesture {
                    reg = com.motAtrouver!.tirage
                    com.showPlusUn = false
                }
            VStack {
                Reglette(reg: $reg, isUserPresent: $isUserPresent, pasLettre: com.pasLettre)
                    .onChange(of: com.phase, initial: true) {
                        if com.phase == .user {
                            reg = (com.optionEnCours == .motPlusUn ? String(com.motAtrouver!.tirage.dropLast()) : com.motAtrouver!.tirage)
                            startDate = Date.now
                            isUserPresent = false
                            com.essais.removeAll()
                        }
                    }
                    .onReceive(timer) { firedDate in
                        if !com.isPause {
                            com.timerSteps += 1
                            if com.tempsEcoule == INHIB_TIME {
                                btnValidDisabled = false
                            }
                            let timerTime = com.optionRapide ? TIMER_TIME_COURT : TIMER_TIME_LONG
                            if com.tempsEcoule > timerTime - WARNING_TIME {
                                cligno = !cligno
                            }
                            if com.tempsEcoule > timerTime {
                                com.horsDelai = true
                                actionBtnValid()
                            }
                        }
                    }
                    .blur(radius: com.isPause ? BLUR_RADIUS : 0)
                Spacer()
                    .frame(height: com.pasLettre)
                HStack(alignment: .top) {
                    Spacer()
                    Button() {
                        if !com.indiceConsomme {
                            com.message = String(localized: "Définition: \(com.defMotAtrouver)")
                        }
                    } label:{
                        Image("loupe")
                            .resizable(resizingMode: .stretch)
                            .frame(width:BTN_SIZE, height:BTN_SIZE )
                    }
                    Spacer()
                    Button() {
                        actionBtnValid()
                    } label:{
                        Image("cible")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 2 * BTN_SIZE, height: 2 * BTN_SIZE)
                    }
                    .disabled(btnValidDisabled)
                    Spacer()
                    Button() {
                        com.showPlusUn = false
                        reg = String(com.motAtrouver!.tirage.sorted())
                    } label:{
                        Image("classement_az")
                            .resizable(resizingMode: .stretch)
                            .frame(width:BTN_SIZE, height:BTN_SIZE )
                    }
                    Spacer()
                }
                Spacer()
                    .frame(height: 10)
            }
            .overlay(com.showPlusUn ?
                     Rectangle()
                        .background(Color.white)
                        .opacity(0.01)
                        .onTapGesture {
                            reg = String(com.motAtrouver!.tirage.sorted())
                            com.showPlusUn = false
                        }
                     : nil)
        }
        .onAppear() {
            reg = com.motAtrouver!.tirage
            com.showPlusUn = (com.optionEnCours == .motPlusUn)
        }
    }
    func actionBtnValid() {
        isUserPresent = true
        com.setReglette(reg: self.reg)
        if  com.dejaTente {
            com.message = String(localized: "Déjà tenté !")
            motAffiche = nil
        } else if com.anagramme  {
            com.message = String(localized: "Anagramme")
            motAffiche = nil
        } else {
            resetTimer()
            btnValidDisabled = true
            com.showPlusUn = (com.optionEnCours == .motPlusUn)
            com.phase = .ordi
        }
    }
    func resetTimer() {
        com.timerSteps = 0
        cligno = false
    }
}
