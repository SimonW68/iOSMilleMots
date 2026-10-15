//
//  Carrousel.swift
//  MilleMots
//
//  Created by Simon Wintz on 21/11/2025.
//

import Foundation
import SwiftUI

struct Carrousel : View {
    @Binding var odsAffiche: Ods9?
    @Binding var motPresse: Mot?
    let sortDescriptors: [NSSortDescriptor]
    let animation = Animation.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 10)
    @State var offsetX: Double = 0
    @State var largVue: Double = 0
    @EnvironmentObject var com : Com
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    FiltreMots(
                        predicate: com.predicateMots,
                        sortDescriptors: sortDescriptors,
                        odsAffiche: $odsAffiche,
                        motPresse: $motPresse,
                    )
                    .offset(x: com.displayOds ? largVue + offsetX : offsetX , y: 0)
                    .disabled(com.displayOds)
                    FiltreOds(
                        odsAffiche: $odsAffiche
                    )
                    .offset(x: com.displayOds ? offsetX : largVue + offsetX, y: 0)
                    .disabled(!com.displayOds)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    largVue = proxy.size.width
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    largVue = proxy.size.width
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > SWIPE_MINI {
                            offsetX = value.translation.width / 2
                        }
                    }
                    .onEnded { value in
                        if value.translation.width > SWIPE_MINI || value.translation.width < -SWIPE_MINI {
                            com.displayOds.toggle()
                        }
                    }
                , isEnabled: com.totalOds != 0
            )
            .onChange(of: com.displayOds) {
                movePage()
            }
        }
    }
    private func movePage() {
        withAnimation(animation) {
            offsetX = -largVue
        }
        offsetX = 0
    }
}
