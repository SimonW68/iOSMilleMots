//
//  Options.swift
//  MilleMots
//
//  Created by Simon Wintz on 15/11/2025.
//

import Foundation
import SwiftUI

struct Options: View {
    @Binding var displayOption: Bool
    @EnvironmentObject var com : Com
    @State var closeWorkItem: DispatchWorkItem?
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.white)
                .opacity(0.01)
                .edgesIgnoringSafeArea(.all)
                
            VStack(alignment: .leading) {
                ForEach(OptionJeu.allCases, id: \.self) { option in
                    RadioButton(option: option, enCours: $com.optionEnCours)
                }
                Divider()
                HStack {
                    Button() {
                        com.optionRapide = true
                    } label: {
                        Image("tortue")
                            .btnStyle()
                    }
                    .frame(maxWidth: .infinity)
                    Button() {
                        com.optionRapide.toggle()
                    } label: {
                        Image("curseur")
                            .btnStyle(LARGE_BTN_SIZE)
                            .rotationEffect(.degrees(com.optionRapide ? 0: 180))
                    }
                    Button() {
                        com.optionRapide = false
                    } label: {
                        Image("lievre")
                            .btnStyle()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .formatVue()
        }
        .onAppear {
            closeAfterDelay()
        }
        .onChange(of: com.optionRapide, initial: false) {
            closeAfterDelay()
        }
        .onChange(of: com.optionEnCours, initial: false) {
            com.listeCorr.removeAll()
            com.getMotsAtrouver.toggle()
            closeAfterDelay()
        }
        .onTapGesture {
            displayOption.toggle()
        }
    }
    private func closeAfterDelay(_ temps: DispatchTimeInterval = TEMPS_HIDE_OPTIONS) {
        cancelClose()
        closeWorkItem = DispatchWorkItem { [self] in
            displayOption = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + temps, execute: closeWorkItem!)
    }
    private func cancelClose() {
        closeWorkItem?.cancel()
    }
}
