//
//  MilleMotsApp.swift
//  MilleMots
//
//  Created by Simon Wintz on 28/02/2024.
//

import SwiftUI
import CoreData

@main
struct MilleMotsApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @AppStorage("sauter-aide") var skipHelp : Bool = false
    let persistenceController = PersistenceController.shared
    var com = Com()
    var del = Def()
    
    var body: some Scene {
        WindowGroup {
            if !skipHelp {
                QuickStart()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.light)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.light)
                    .environmentObject(del)
                    .environmentObject(com)
                    .environmentObject(networkMonitor)
            }
        }
    }
}




