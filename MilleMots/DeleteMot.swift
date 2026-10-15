//
//  DeleteMot.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/06/2024.
//

import Foundation
import SwiftUI

struct DeleteMot : View {
    @Binding var mot : Mot?
    @Binding var alerte : Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    var body : some View {
        if mot != nil && alerte == true {
            VStack {
                let message = "Supprimer \(mot!.graphie!)"
                let action = "A N N U L E R"
                Spacer()
                    .frame(height: 40)
                HStack {
                    Text(message)
                    Spacer()
                    Button(action) {
                        alerte = false
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
                        if alerte == true {
                            deleteMot(context: viewContext, mot: mot!)
                            alerte = false
                            mot = nil
                        }
                    }
                }
            }
        }
    }
}
