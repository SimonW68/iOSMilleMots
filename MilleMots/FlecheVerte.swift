//
//  FlecheVerte.swift
//  MilleMots
//
//  Created by Simon Wintz on 22/11/2025.
//

import Foundation
import SwiftUI

struct FlecheVerte: View {
    @State var spacing: CGFloat = -5.0
    @State var x: CGFloat = 0
    
    private var animation: Animation {
        .easeInOut(duration: 0.4)
        .repeatForever(autoreverses: true)
    }
    private var animationSwipe: Animation {
        .linear(duration: 0.8)
        .repeatForever(autoreverses: false)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (spacing: spacing) {
                    Spacer()
                    Text("\u{25B6}")
                    Text("\u{25B6}")
                    Text("\u{25B6}")
                }
                .padding()
                .font(.system(size: 40, weight: .bold, design: .default))
                .foregroundColor(Color("vert"))
                .onAppear {
                    withAnimation(animation) {
                        spacing = -15.0
                    }
                }
                HStack {
                    Spacer()
                    Image("swipe")
                        .resizable()
                        .frame(width: 2 * BTN_SIZE, height: 2 * BTN_SIZE)
                        .offset(x: x)
                        .onAppear {
                            withAnimation(animationSwipe) {
                                x = -30.0
                            }
                        }
                }
            }
        }
    }
}
