//
//  companyViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-27.
//

import Foundation
import FirebaseFirestore

class companyViewModel: ObservableObject {
    
    @Published var company = [Company]()
    private var db = Firestore.firestore()
    
    func fetchData(category: String) {
        db.collection("locations").document("ztjn3j9q7gSonpXEAez0").collection("companies").whereField("categories", arrayContains: category).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.company = documents.map { (queryDocumentSnapshot) -> Company in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                let location = data["location"] as! GeoPoint
                let categories = data["categories"] as? [String] ?? []
                return Company(id: id, name: name, address: address, location: location, categories: categories)
            }
        }
    }
}
