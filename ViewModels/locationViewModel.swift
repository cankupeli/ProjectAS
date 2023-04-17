//
//  locationViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-14.
//

import Foundation
import FirebaseFirestore

class locationViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var currentLocation = Location(name: "UNDEFINED", description: "UNDEFINED")
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("locations").getDocuments() { [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.locations = documents.map { (queryDocumentSnapshot) -> Location in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                if (queryDocumentSnapshot.documentID  == "ztjn3j9q7gSonpXEAez0"){
                    self.currentLocation.name = name
                    self.currentLocation.description = description
                }
                return Location(id:id, name: name, description: description)
            }
        }
    }
}
