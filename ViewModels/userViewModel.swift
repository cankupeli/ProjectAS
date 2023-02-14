//
//  userViewModel.swift
//  ProjectAS
//
//  Created by Eric Johansson on 2023-02-07.
//

import Foundation
import FirebaseFirestore

class userViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let first = data["first"] as? String ?? ""
                let last = data["last"] as? String ?? ""
                let age = data["age"] as? Int ?? 0
                return User(id:id, first: first, last: last, age: age)
            }
        }
    }
}
