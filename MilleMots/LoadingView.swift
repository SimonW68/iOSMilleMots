//
//  LoadingView.swift
//  MilleMots
//
//  Created by Simon Wintz on 30/06/2024.
//

import Foundation
import SwiftUI

struct LoadingView : View {
    let opacity: Double
    init(opacity: Double = 1.0){
        self.opacity = opacity
    }
    var body : some View {
        VStack {
            Text("Chargement des données...")
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.white).opacity(opacity))
    }
}
