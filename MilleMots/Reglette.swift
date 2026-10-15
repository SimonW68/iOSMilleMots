//
//  Regl.swift
//  MilleMots
//
//  Created by Simon Wintz on 04/02/2025.
//
import Foundation
import SwiftUI

struct Reglette : View {
    @Binding var reg: String
    @Binding var isUserPresent: Bool
    var pasLettre: CGFloat
    @State var reglette: [Tuile]=[]
    @State var decReglette = [CGSize]()
    @State var newTransl : Double = .zero
    @State var deltaCases: Int = 0
    @EnvironmentObject var com : Com
    
    init(
        reg: Binding<String>,
        isUserPresent: Binding<Bool>,
        pasLettre: CGFloat
    ) {
        self._reg = reg
        self._isUserPresent = isUserPresent
        self.pasLettre = pasLettre
    }
    
    var body: some View {
        HStack(spacing: EP_FILET) {
            ForEach(reglette.indices, id: \.self) {index in
                let myTuile = reglette[index]
                Text(String(myTuile.lettre))
                    .formatTuile(tuileSize: pasLettre - EP_FILET)
                    .offset(x: myTuile.positionX + decReglette[index].width, y: decReglette[index].height)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isUserPresent = true
                                decReglette[index] = gesture.translation
                                newTransl = gesture.translation.width / pasLettre - Double(deltaCases)
                                if newTransl > 0.5 && index + deltaCases < reg.count - 1 {
                                    myTuile.decalageD(pasLettre: pasLettre)
                                    deltaCases += 1
                                }
                                if newTransl < -0.5 && index + deltaCases > 0 {
                                    myTuile.decalageG(pasLettre: pasLettre)
                                    deltaCases -= 1
                                }
                            }
                            .onEnded { _ in
                                myTuile.positionX = Double(deltaCases) * pasLettre
                                reg = String(reglette.sorted(by: {$0.position < $1.position}).map {$0.lettre})
                                decReglette[index] = .zero
                                deltaCases = .zero
                            }
                    )
                    .dynamicTypeSize(.xxxLarge)
                    .multilineTextAlignment(.center)
                    .alignmentGuide(VerticalAlignment.center) {_ in 0 }
            }
        }
        .onChange(of: com.horsDelai){
            for index in 0 ..< reglette.count {
                decReglette[index] = .zero
            }
        }
        .onChange(of: reg, initial: true) {
            decReglette = Array(repeating: .zero, count: reglette.count)
            deltaCases = .zero
            reglette.removeAll()
            for (index, char) in reg.enumerated() {
                let newLettre = Tuile(car: char, ind: index, voisinG: index > 0 ? reglette[index - 1] : nil)
                reglette.append(newLettre)
            }
            decReglette.removeAll()
            decReglette.append(contentsOf: Array(repeating: .zero, count: reglette.count))
        }
    }
}
