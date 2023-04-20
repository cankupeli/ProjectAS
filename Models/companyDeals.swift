//
//  company.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-27.
//

import Foundation

struct CompanyDeals: Identifiable{
    var id: String = UUID().uuidString
    var title: String
    var price: String
    var description: String
    var type: String
}
