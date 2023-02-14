//
//  user.swift
//  ProjectAS
//
//  Created by Eric Johansson on 2023-02-07.
//

import Foundation

struct User: Identifiable{
    var id: String = UUID().uuidString
    var first: String
    var last: String
    var age: Int
}
