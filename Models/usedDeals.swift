//
//  usedDeals.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-28.
//

import Foundation
import FirebaseFirestore
struct UsedDeals: Identifiable{
    var id: String = UUID().uuidString
    var activated: Timestamp
}
