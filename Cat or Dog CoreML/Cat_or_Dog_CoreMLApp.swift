//
//  Cat_or_Dog_CoreMLApp.swift
//  Cat or Dog CoreML
//
//  Created by Arrinal Sholifadliq on 24/01/22.
//

import SwiftUI

@main
struct Cat_or_Dog_CoreMLApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
