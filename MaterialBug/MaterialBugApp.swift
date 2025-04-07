//
//  MaterialBugApp.swift
//  MaterialBug
//
//  Created by Phil Zakharchenko on 4/6/25.
//

import SwiftUI

@main
struct MaterialBugApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MaterialBugDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
