//
//  location.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-14.
//

import Foundation

struct Location: Identifiable{
    var id: String = UUID().uuidString
    var name: String
    var description: String
}
