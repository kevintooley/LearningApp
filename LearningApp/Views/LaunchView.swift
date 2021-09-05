//
//  LaunchView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/21/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.loggedIn == false {
            // Show login view
            LoginView()
                .onAppear(perform: {
                    // Check if user is logged in
                    model.checkLogin()
                })
        }
        else {
            // Show logged in view
            TabView {
                
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
                
                
                
            }
            .onAppear(perform: {
                model.getModules()
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                
                // Save data to DB when app is going to foreground to background
                model.saveData(writeToDatabase: true)
            })
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
