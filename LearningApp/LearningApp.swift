//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
