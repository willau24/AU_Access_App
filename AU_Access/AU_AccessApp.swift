//
//  AU_AccessApp.swift
//  AU_Access
//
//  Created by Will McCormick on 2/27/23.
//

import SwiftUI

@main
struct AU_AccessApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
