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
    @Published var currentLocation = Location(id: "ztjn3j9q7gSonpXEAez0", name: "Sundsvall", location: GeoPoint(latitude: 62.3908, longitude: 17.3069), description: "")
    private var db = Firestore.firestore()
    func update(place: String){
        let index = locations.firstIndex(where: {$0.name == place})
        currentLocation = locations[index!]

    }
    func fetchData() {
        db.collection("locations").getDocuments() { [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.locations = documents.map { (queryDocumentSnapshot) -> Location in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let location = data["coordinates"] as? GeoPoint ?? GeoPoint(latitude: 0,longitude: 0)
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                if (queryDocumentSnapshot.documentID  == currentLocation.id){
                    self.currentLocation.id = id
                    self.currentLocation.name = name
                    self.currentLocation.description = description
                }
                return Location(id:id, name: name, location: location, description: description)
            }
        }
    }
}
