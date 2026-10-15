//
//  Message.swift
//  MilleMots
//
//  Created by Simon Wintz on 06/05/2024.
//

import Foundation
import SwiftUI

struct Message : View {
    @EnvironmentObject var com : Com
    
    var body : some View {
        VStack {
            Spacer()
                .frame(height: 40)
            Text(com.message)
                .formatMessage()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(com.message.dureeMessage())) {
                        com.message = VIDE
                    }
                }
        }
    }
}

