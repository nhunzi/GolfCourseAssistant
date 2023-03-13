//
//  File.swift
//  GCALogin
//
//  Created by Nick Hunziker on 3/4/23.
//

import Foundation

// MARK: - CourseScoreCard
struct CourseScorecard: Codable {
    let courseid: Int
    let holeteeboxes: [Holeteebox]
    let coursename: String
}

// MARK: - Holeteebox
struct Holeteebox: Codable {
    let holeid, holenumber: Int
    let color: Color
    let length, par, handicap: Int
    let teeboxtype: Teeboxtype
}

enum Color: String, Codable {
    case blue = "Blue"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
}

enum Teeboxtype: String, Codable {
    case championship = "Championship"
    case menS = "Men's"
    case pro = "Pro"
    case womenS = "Women's"
}
