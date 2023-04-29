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
class companyViewModel: ObservableObject {
    @Published var selectedView: String = "all"
    @Published var calloutStatus: Bool = false
    @Published var currentCompanyType = [Company]()
    @Published var companyAll = [Company]()
    @Published var companyFood = [Company]()
    @Published var companyShopping = [Company]()
    @Published var companyService = [Company]()
    @Published var companyActivities = [Company]()
    private var db = Firestore.firestore()
    func update(companyType: [Company], selectedView: String){
        currentCompanyType = companyType
        self.selectedView = selectedView
    }
    func fetchData(location: String) {
        self.companyAll.removeAll()
        self.companyFood.removeAll()
        self.companyShopping.removeAll()
        self.companyService.removeAll()
        self.companyActivities.removeAll()
        db.collection("locations").document(location).collection("companies").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.companyAll = documents.map { (queryDocumentSnapshot) -> Company in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let location = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0,longitude: 0)
                let categories = data["categories"] as? [String] ?? []
                if (categories.contains("food")){
                    self.companyFood.append(Company(id: id, name: name, address: address, description: description, type: type, location: location, categories: categories))
                }
                if (categories.contains("shopping")){
                    self.companyShopping.append(Company(id: id, name: name, address: address, description: description, type: type, location: location, categories: categories))
                }
                if (categories.contains("service")){
                    self.companyService.append(Company(id: id, name: name, address: address, description: description, type: type, location: location, categories: categories))
                }
                if (categories.contains("activities")){
                    self.companyActivities.append(Company(id: id, name: name, address: address, description: description, type: type, location: location, categories: categories))
                }
                return Company(id: id, name: name, address: address, description: description, type: type, location: location, categories: categories)
            }
        }
    }

    /*func fetchData(category: String) {
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
    }*/
}
