//
//  Player.swift
//  GCALogin
//
//  Created by Cara du Preez on 4/1/23.
//

import Foundation
import UIKit

class Player{
    
    private let userID: String
    private let userName: String
    private let userEmail: String
    
    init(userID: String, userName: String, userEmail: String) {
        self.userID = userID
        self.userName = userName
        self.userEmail = userEmail
    }
    
    func getName() -> String
    {
        return userName
    }
    
    func getEmail() -> String
    {
        return userEmail
    }
    
}

