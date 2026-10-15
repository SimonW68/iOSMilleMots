//
//  ToogleStatusMot.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/06/2024.
//

import Foundation
import SwiftUI

struct ToggleStatusMot : View {
    @Binding var mot : Mot?
    @State var message : String
    @Environment(\.managedObjectContext) private var viewContext
    
    init(mot: Binding<Mot?>) {
        self._mot = mot
        message = ""
        if self.mot != nil {
            self.message = if self.mot!.baseActive { "Désactiver \(self.mot!.graphie!)"} else { "Réactiver \(self.mot!.graphie!)" }
        }
    }
    
    var body : some View {
        VStack {
            if self.mot != nil {
                SnackBar1(message: $message, action: { toggleStatusMot(context: viewContext, mot: mot!) })
                    .onChange(of: message, initial: false) {
                        if message == "" {
                            mot = nil
                        }
                    }
            }
        }
    }
}
