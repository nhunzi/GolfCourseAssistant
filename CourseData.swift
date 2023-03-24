import Foundation

// MARK: - Welcome5
struct CourseData{
    let resources: [Resource]
}

// MARK: - Resource
struct Resource{
    let id, number, courseid: Int
    let rotation: Double?
    let range: Range?
    let dimensions: Dimensions?
    let vectors: [Any?]?
    let flagcoords: Flagcoords?
}

// MARK: - Dimensions
struct Dimensions{
    let width, height: Int
}

// MARK: - Flagcoords
struct Flagcoords{
    let lat, long: Double
}

// MARK: - Range
struct Range{
    let x, y: X
}

// MARK: - X
struct X{
    let min, max: Double
}
