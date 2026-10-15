//
//  SnackBar.swift
//  MilleMots
//
//  Created by Simon Wintz on 31/05/2024.
//

import Foundation
import SwiftUI

struct ToggleStatusMot : View {
    @Binding var mot : Mot?
    @Environment(\.managedObjectContext) private var viewContext
    
    var body : some View {
        VStack {
            if self.mot != nil {
                let message = if mot!.baseActive { "Désactiver \(mot!.graphie!)"} else { "Réactiver \(mot!.graphie!)" }
                let action = "A N N U L E R"
                Spacer()
                    .frame(height: 40)
                HStack {
                    Text(message)
                    Spacer()
                    Button(action) {
                        mot = nil
                    }
                    .foregroundColor(.purple)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.black)
                .foregroundColor(.white)
                .dynamicTypeSize(.xSmall)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + SNACK_TIME) {
                        if self.mot != nil {
                            toggleStatusMot(context: viewContext, mot: self.mot!)
                            self.mot = nil
                        }
                    }
                }
            }
        }
    }
}
