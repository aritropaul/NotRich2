//
//  NotRich2App.swift
//  NotRich2
//
//  Created by Aritro Paul on 24/05/21.
//

import SwiftUI

@main
struct NotRich2App: App {
    
    @StateObject private var model: Model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.model)
                .toolbar {
                    ToolbarItemGroup(placement: ToolbarItemPlacement.automatic, content: {
                        Button(action: { model.requestData() }, label: {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        })
                    })
                }
        }
        .windowStyle(DefaultWindowStyle())
    }
}
