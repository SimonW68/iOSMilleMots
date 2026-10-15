//
//  AppDelegate.swift
//  MilleMots
//
//  Created by Simon Wintz on 02/04/2025.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let params = components.queryItems else {
            print("Invalid URL or album path missing")
            return false
        }
        
        if let mots = params.first(where: {$0.name == "mots"})?.value {
            print("mots = \(mots)")
            return true
        } else {
            print("argument 'mots' manquant")
            return false
        }
    }
}
