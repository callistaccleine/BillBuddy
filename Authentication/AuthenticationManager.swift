//
//  AuthenticationManager.swift
//  BillBuddy
//
//  Created by Whissely SW on 17/3/2025.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
    }
    
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager ()
    private init () { }

    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        
        
    }
}

