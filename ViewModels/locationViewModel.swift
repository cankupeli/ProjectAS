//
//  locationViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-02-14.
//

import Foundation
import FirebaseFirestore

class locationViewModel: ObservableObject {
    
    @Published var location = [Location]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("locations").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.location = documents.map { (queryDocumentSnapshot) -> Location in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                return Location(id:id, name: name, description: description)
            }
        }
    }
}
