//
//  Cartouche.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/10/2025.
//
import Foundation
import SwiftUI

public struct CartLong: View {
    @Binding var lMin: Int
    @Binding var lMax: Int
    let hideTool: (DispatchTimeInterval) -> Void
    @State var marginStart : Double = .zero
    @State var marginEnd : Double = .zero
    @State var coteLmin : Bool = true
    @State var longCartouche : CGFloat = .zero
    @State var pasNombre : CGFloat = .zero
    @EnvironmentObject var com : Com
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("fondbleu"))
                    .stroke(.black, lineWidth: 1)
                    .frame(height: SELECTOR_SIZE)
                    .padding(EdgeInsets(
                        top: 0,
                        leading:  marginStart,
                        bottom: 0,
                        trailing: marginEnd
                    ))
                HStack(spacing: .zero) {
                    ForEach (3..<10) { number in
                        Text("\(number)")
                            .bold()
                            .dynamicTypeSize(.xxxLarge)
                            .monospaced()
                            .frame(maxWidth:.infinity)
                            .onTapGesture {
                                hideTool(TEMPS_HIDE_FILTRE_TOOL)
                                if number == lMin {
                                    lMax = coerce(n: number)
                                } else if number == lMax {
                                    lMin = coerce(n: number)
                                } else if number < lMin {
                                    lMin = coerce(n: number)
                                } else if number > lMax {
                                    lMax = coerce(n: number)
                                } else if coteLmin {
                                    lMin = coerce(n: number)
                                    coteLmin = false
                                } else {
                                    lMax = coerce(n: number)
                                    coteLmin = true
                                }
                                com.applyFilter()
                            }
                    }
                }
            }
            .onChange(of: lMin) {
                marginStart = CGFloat(lMin - LONGUEUR_MOT_MIN) * pasNombre
            }
            .onChange(of: lMax) {
                marginEnd = CGFloat(LONGUEUR_MOT_MAX - lMax) * pasNombre
            }
            .onAppear() {
                longCartouche = geometry.size.width
                pasNombre = longCartouche / CGFloat(1 + LONGUEUR_MOT_MAX - LONGUEUR_MOT_MIN)
                marginStart = CGFloat(lMin - LONGUEUR_MOT_MIN) * pasNombre
                marginEnd = CGFloat(LONGUEUR_MOT_MAX - lMax) * pasNombre
            }
        }
        .frame(height: SELECTOR_SIZE)
    }
}
