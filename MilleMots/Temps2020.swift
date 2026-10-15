//
//  Temps2020.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/05/2024.
//

import Foundation
import SwiftUI

struct Temps2020 : View {
    @State var departChrono20 : Date
    @State var elapsedTime : Int
    @State var isVisible : Bool = true
    @State var duration : Int = 0
    @AppStorage(USER_nTirages) var nTirages : Int = DEFAULT_nTirages
    @AppStorage(USER_20_20_RECORD) var record2020 : Int = DEFAULT_20_20_RECORD
    
    var body: some View {
        HStack (spacing: 0) {
            Image("chronometre")
                .resizable(resizingMode: .stretch)
                .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
            Text("\(durationToString(duration: duration))  -  (")
                .dynamicTypeSize(.xLarge)
            Image("record")
                .resizable(resizingMode: .stretch)
                .frame(width: SMALL_BTN_SIZE, height: SMALL_BTN_SIZE)
            Text("\(durationToString(duration: record2020)) )")
                .dynamicTypeSize(.xLarge)
        }
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            duration = elapsedTime + Int(Date.now.timeIntervalSince(departChrono20))
            if nTirages == 20 && duration < record2020 {
                var BlinkCount = 0
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    isVisible.toggle()
                    BlinkCount += 1
                    if BlinkCount >= 10 {
                        timer.invalidate()
                    }
                }
            }
        }
        .onDisappear {
            if record2020 == 0 || duration < record2020 {
                record2020 = duration
            }
        }
    }
}

func durationToString(duration: Int) -> String {
    let minutes = duration / 60
    let seconds = duration % 60
    return String(format: "%02d:%02d", minutes, seconds)
}
