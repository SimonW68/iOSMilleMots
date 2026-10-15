//
//  ExportSug.swift
//  MilleMots
//
//  Created by Simon Wintz on 24/11/2025.
//

import Foundation
import SwiftUI



struct ExportSug: View {
    @FetchRequest(entity: Definition.entity(), sortDescriptors: [])
    private var defs: FetchedResults<Definition>
    var body: some View {
        Text("ExportSug")
    }
}
