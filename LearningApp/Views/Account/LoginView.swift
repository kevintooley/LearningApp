//
//  LoginView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/21/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Login"
        }
        else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        
        VStack (spacing: 10) {
            
            Spacer()
            
            Group {
                // Logo
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150)
                
                // Title
                Text("Learnzilla")
            }
            
            Spacer()
            
            // Picker
            Picker(selection: $loginMode, label: Text("Hey")) {
                
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Group {
                
                // Form
                TextField("Email", text: $email)
                
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            
            // Button
            Button(action: {
                if loginMode == Constants.LoginMode.login {
                    // log the user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                        // Check for errors
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        // Clear error message
                        self.errorMessage = nil
                        
                        // Fetch the local user meta data
                        self.model.getUserData()
                        
                        // change the view to logged in view
                        self.model.checkLogin()
                        
                    }
                }
                else {
                    // Create a new account
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        // Clear error message
                        self.errorMessage = nil
                        
                        // Save the first name
                        let firebaseuser = Auth.auth().currentUser
                        let db = Firestore.firestore()
                        let ref = db.collection("users").document(firebaseuser!.uid)
                        
                        ref.setData(["name": name], merge: true)
                        
                        // Update meta data
                        let user = UserService.shared.user
                        user.name = name
                        
                        // change the view to logged in view
                        self.model.checkLogin()
                        
                    }
                }
            }, label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .frame(height: 40)
                        .cornerRadius(10)
                    
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            })
            
            Spacer()
            
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
