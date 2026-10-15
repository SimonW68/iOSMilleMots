//
//  Message.swift
//  MilleMots
//
//  Created by Simon Wintz on 06/05/2024.
//

import Foundation
import SwiftUI

struct Message : View {
    @State var pasLettre : Double
    @EnvironmentObject var com : Com
    
    var body : some View {
        Text(com.message)
            .formatMsg(pasLettre: pasLettre)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + MESSAGE_TIME) {
                    com.message = ""
                }
            }
    }
}
