//
//  SnackBar.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/06/2024.
//

import Foundation
import SwiftUI

struct SnackBar : View {
    let message : String
    let labelAction : String
    let isLong : Bool
    let action : () -> Void
    let endSnack : () -> Void
    @Environment(\.managedObjectContext) private var viewContext
    
    var body : some View {
        HStack {
            Text(message)
            Spacer()
            Button(labelAction) {
                action()
            }
            .foregroundColor(.orange)
        }
        .formatMessage()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + (isLong ? SNACK_TIME_LONG : SNACK_TIME_SHORT)) {
                endSnack()
            }
        }
    }
}
