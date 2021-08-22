//
//  ProfileView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/21/21.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        Button(action: {
            
            try! Auth.auth().signOut()
            
            model.checkLogin()
            
        }, label: {
            Text("Sign Out")
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
