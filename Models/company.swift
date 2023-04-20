//
//  company.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-27.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Company: Identifiable{
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var description: String
    var type: String
    var location:  GeoPoint
    var categories: Array<String>
}
