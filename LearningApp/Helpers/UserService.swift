//
//  UserService.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/22/21.
//

import Foundation

/*
 This is a singleton class that only allows for one instance of a user at a time.
 The private init() method means that you can't call it from anywhere else, and this is accessed
 with UserService.shared.user whenever we need to access the user meta data
 */
class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
