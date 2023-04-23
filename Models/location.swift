//
//  location.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-14.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Location: Identifiable, Hashable{
    var id: String = UUID().uuidString
    var name: String
    var location:  GeoPoint
    var description: String
}
