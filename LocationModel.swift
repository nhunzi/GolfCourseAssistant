//
//  LocationModel.swift
//  GCALogin
//
//  Created by student on 3/8/23.
//

import Foundation

class LocationModel: NSObject {
    
    //properties
    
    var Id: Int?
    var latitude: String?
    var longitude: String?
    var Name: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(Id: Int, latitude: String, longitude: String, Name: String) {
        
        self.Id = Id
        self.latitude = latitude
        self.longitude = longitude
        self.Name = Name
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(Name), Id: \(Id), Latitude: \(latitude), Longitude: \(longitude)"
        
    }
    
    
}
