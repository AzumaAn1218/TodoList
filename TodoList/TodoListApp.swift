//
//  TodoListApp.swift
//  TodoList
//
//  Created by 橋本丈太郎 on 2024/05/05.
//

import SwiftUI

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
