//
//  CourseData.swift
//  GCALogin
//
//  Created by Nick Hunziker on 3/2/23.
//
// This file contains the structs for all the individual course data to be decoded from Golfbert API
//

import Foundation

// MARK: - Course
struct CourseData: Codable {
    let resources: [Resource]
}

// MARK: - Resource
struct Resource: Codable {
    let id, number, courseid: Int
    let rotation: Double
    let range: Range
    let dimensions: Dimensions
    let vectors: [Vector]
    let flagcoords: Flagcoords
}

// MARK: - Dimensions
struct Dimensions: Codable {
    let width, height: Int
}

// MARK: - Flagcoords
struct Flagcoords: Codable {
    let lat, long: Double
}

// MARK: - Range
struct Range: Codable {
    let x, y: X
}

// MARK: - X
struct X: Codable {
    let min, max: Double
}

// MARK: - Vector
struct Vector: Codable {
    let type: TypeEnum
    let lat, long: Double
}

enum TypeEnum: String, Codable {
    case blue = "Blue"
    case flag = "Flag"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
}
