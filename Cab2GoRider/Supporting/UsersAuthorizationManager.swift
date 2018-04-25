//
//  UsersAuthenticationManager.swift
//  Cab2GoRider
//
//  Created by Yevhenii on 22.04.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ message: String?) -> Void

struct LoginErrorCodeMessage {
    static let invalidEmailMessage = "Invalid Email Address. Please, Provide an Valid Email Address"
    static let wrongPasswordMessage = "Wrong Password. Please, Enter The Correct Password"
    static let problemConnectingMessage = "Cannot Connect to Database. Please, Try Again Later"
    static let userNotFoundMessage = "User Not Found. Please, Sign Up"
    static let emailAlreadyInUseMessage = "Email Is Already In Use. Please, Use Another Email"
    static let weakPasswordMessage = "Password Should Be At Least 6 Characters Long"
}

class UsersAuthorizationManager {
    
    private static let instance = UsersAuthorizationManager()
    
    static var authManager: UsersAuthorizationManager {
        
        return instance
        
    }
    
    func login(email email: String, password: String, loginHandler: LoginHandler?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
            
            if error != nil {
                
                self.handleErrors(error: error! as NSError, loginHandler: loginHandler)
                
            } else {
                
                loginHandler?(nil)
                
            }
            
            //Handle user authorization
            
        })
        
    }
    
    private func handleErrors(error: NSError, loginHandler: LoginHandler?) {
        
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            
            switch errorCode {
                
            case .wrongPassword:
                loginHandler?(LoginErrorCodeMessage.wrongPasswordMessage)
            case .invalidEmail:
                loginHandler?(LoginErrorCodeMessage.invalidEmailMessage)
            case .userNotFound:
                loginHandler?(LoginErrorCodeMessage.userNotFoundMessage)
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCodeMessage.emailAlreadyInUseMessage)
            case .weakPassword:
                loginHandler?(LoginErrorCodeMessage.weakPasswordMessage)
            default:
                loginHandler?(LoginErrorCodeMessage.problemConnectingMessage)
                
            }
            
        }
        
    }
    
    
}

