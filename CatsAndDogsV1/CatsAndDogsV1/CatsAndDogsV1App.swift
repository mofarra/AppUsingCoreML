//
//  CatsAndDogsV1App.swift
//  CatsAndDogsV1
//
//  Created by Mohamad Alfarra on 3/27/23.
//

import SwiftUI

@main
struct CatsAndDogsV1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
