//
//  CircularProgressBar.swift
//  MilleMots
//
//  Created by Simon Wintz on 08/04/2024.
//

import Foundation
import SwiftUI

struct ChronoTimer: View {
    let progress: Double
    let cligno: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(cligno ? Color("fondbleu") : Color("fondvert"))
                .stroke(
                    Color(Color.black),
                    lineWidth: 1
                )
            if progress != 0 {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke (
                        Color("vert"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round
                        )
                    )
                    .padding(1.5)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
            } else {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color("vert"),
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}
