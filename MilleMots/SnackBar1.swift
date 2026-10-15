//
//  SnackBar1.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/06/2024.
//

import Foundation
import SwiftUI

struct SnackBar1 : View {
    @Binding var message : String
    @State var action : () -> Void
    @State var actionLabel = "A N N U L E R"

    var body : some View {
        VStack {
            if self.message != "" {
                Spacer()
                    .frame(height: 40)
                HStack {
                    Text(message)
                    Spacer()
                    Button(actionLabel) {
                        message = ""
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
                        action()
                        message = ""
                    }
                }
            }
        }
    }
}
