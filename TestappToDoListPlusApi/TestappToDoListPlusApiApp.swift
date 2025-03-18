//
//  TestappToDoListPlusApiApp.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

@main
struct TestappToDoListPlusApiApp: App {
    var body: some Scene {
        WindowGroup {
            ToDoListView()
                .preferredColorScheme(.dark)
        }
    }
}
