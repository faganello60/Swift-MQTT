//
//  Mqtt_ClientApp.swift
//  Mqtt-Client
//
//  Created by Bruno Faganello on 19/07/22.
//

import SwiftUI

@main
struct Mqtt_ClientApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ConnectionList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
