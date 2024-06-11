//
//  ContentView.swift
//  TodoList
//
//  Created by 橋本丈太郎 on 2024/05/05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selection = 1
    var body: some View {
        TabView(selection: $selection) {

            CalenderPage()
                .tabItem {
                    Label("カレンダー", systemImage: "1.circle")
                }
                .tag(1)

            TodoListPage()
                .tabItem {
                    Label("タスク", systemImage: "2.circle")
                }
                .tag(2)

            AnalyticsPage()
                .tabItem {
                    Label("アナリティクス", systemImage: "3.circle")
                }
                .tag(3)

        } // TabView ここまで
    } // bodyここまで
} // ContentViewここまで


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
