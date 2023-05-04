//
//  DBData.swift
//  GCALogin
//
//  Created by Cara du Preez on 4/7/23.
//

import Foundation
import GRDB



// Define a record type
struct myGolfer: Codable, FetchableRecord, PersistableRecord {
    var Userid: String
    var UserName: String
    var Email: String
}

struct Course: Codable, FetchableRecord, PersistableRecord {
    var CourseID: Int
    var Name: String
    
}

struct Hole: Codable, FetchableRecord, PersistableRecord {
    var CourseID: Int
    var holeID: Int
    var Holenumber: Int
    var flagLat: Double
    var flagLong: Double
    
}

struct Feedback: Codable, FetchableRecord, PersistableRecord {
    var Userid: String
    var CourseID: Int
    var holeID: Int
    var Comment: String
    var Date: String
    
}

struct ShotLocation : Codable, FetchableRecord, PersistableRecord {
    var CourseID: Int
    var holeID: Int
    var Date: String
    var lat: Double
    var long: Double
    var shot_number: Int
}
