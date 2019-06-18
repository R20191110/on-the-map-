//
//  studentLocation.swift
//  on the map
//
//  Created by mac pro on 12/09/1440 AH.
//  Copyright © 1440 mac pro. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt : String
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mapString : String
    var mediaURL : String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String

}
