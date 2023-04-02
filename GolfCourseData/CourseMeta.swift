//
//  CourseMeta.swift
//  GCALogin
//
//  Created by Nick Hunziker on 3/2/23.
//
// This file contains the structs for the course meta data to be decoded from Golfbert API
//

import Foundation


// MARK: - CourseDetails
struct CourseMeta: Codable {
    let id: Int
    let address: Address
    let name, phonenumber: String
    let coordinates: Coordinates
}

// MARK: - Address
struct Address: Codable {
    let country, street, city, state: String
    let zip: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, long: Double
}
