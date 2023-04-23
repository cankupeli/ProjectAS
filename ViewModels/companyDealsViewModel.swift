//
//  companyViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-27.
//

import Foundation
import FirebaseFirestore
/*
 Sundsvall: "ztjn3j9q7gSonpXEAez0"
 Stockholm: "Igo92nJxwwkZ78aSoMQ0"
 */
class companyDealsViewModel: ObservableObject {
    @Published var companyDeals = [CompanyDeals]()    
    private var db = Firestore.firestore()
    func fetchData(company: String,location: String) {
        db.collection("locations").document(location).collection("companies").document(company).collection("deals").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.companyDeals = documents.map { (queryDocumentSnapshot) -> CompanyDeals in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let price = data["price"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                return CompanyDeals(id: id, title: title, price: price, description: description, type: type)
            }
        }
    }
}
