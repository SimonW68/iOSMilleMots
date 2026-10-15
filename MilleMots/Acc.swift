//
//  Acc.swift
//  MilleMots
//
//  Created by Simon Wintz on 28/05/2026.
//

import Foundation
import SwiftUI

struct Acc: View {
    let words: [String]
    let prefix: String
    @EnvironmentObject var com: Com
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(
                words.chunked(prefix: prefix, font: UIFont.preferredFont(forTextStyle: .title3), maxWidth: com.largView),
                id: \.self
            ) { line in
                HStack(spacing: 0) {
                    ForEach(line, id: \.self) { mot in
                        Text("\(mot == words.first ? prefix : "")\(mot)\(mot == words.last ? "" : ", ")")
                            .font(.title3)
                            .onTapGesture {
                                com.pause(true)
                                com.path.append(DataObject(name: "dico", payload: mot))
                            }
                    }
                }
            }
        }
    }
}
