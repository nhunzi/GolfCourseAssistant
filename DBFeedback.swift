//
//  DBFeedback.swift
//  GCALogin
//
//  Created by Cara du Preez on 3/31/23.
//

import Foundation
class Feedback {
 
    var id: Int
    var name: String?
    var powerRanking: Int
 
    init(id: Int, name: String?, powerRanking: Int){
        self.id = id
        self.name = name
        self.powerRanking = powerRanking
    }
}
