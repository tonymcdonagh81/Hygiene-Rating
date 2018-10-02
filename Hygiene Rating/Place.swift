//
//  Place.swift
//  Hygiene App 2
//
//  Created by Tony Mcdonagh on 20/03/2018.
//  Copyright © 2018 Tony McDonagh. All rights reserved.
//

import Foundation
//Place object to handle the json data
class Place: Codable{
    
    let BusinessName: String
    let AddressLine1: String?
    let AddressLine2: String?
    let AddressLine3: String?
    let PostCode: String?
    let RatingValue: String?
    let RatingDate: String?
    let Latitude: String?
    let Longitude: String?
    let DistanceKM: String?
    
}
