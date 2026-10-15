//
//  Definition.swift
//  Jarnac
//
//  Created by Simon Wintz on 27/11/2024.
//

import Foundation
import SwiftUI
import SwiftSoup

class Def : ObservableObject {
    @Published var mots: String = ""
    @Published var definition: String = ""
    @Published var utiliserDef: Bool = false
}

struct DefEnLigne : View {
    @Binding var displayDef: Bool
    @State var mot: String
    @EnvironmentObject var del : Def
    @State var elimot : Elimot = Elimot()

    var body: some View {
        VStack {
            Text("**\(elimot.motDic)** \(elimot.defElimots)")
                .font(Font.body.weight(.regular))
            HStack {
                Button (CANCEL) {
                    displayDef = false
                }
                .dynamicTypeSize(.xLarge)
                .foregroundColor(.white)
                Spacer()
                if !elimot.def.isEmpty || elimot.mots != mot {
                    Button () {
                        del.utiliserDef = true
                        del.mots = elimot.mots
                        del.definition = elimot.def
                        displayDef = false
                    } label: {
                        Image("utiliser")
                            .resizable(resizingMode: .stretch)
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                    }
                }
            }
            Text("(source : elimots.com)")
                .font(Font.footnote.weight(.regular))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        .background(.black)
        .foregroundColor(.white)
        .onAppear(){
            ConsultElimots().getDef(mot: mot) { elimot in
                self.elimot = elimot
            }
        }
    }
}

