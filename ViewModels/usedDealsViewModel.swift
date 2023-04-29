//
//  usedDealsViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-28.
//

import Foundation
import FirebaseFirestore

class usedDealsViewModel: ObservableObject {
    
    @Published var usedDeals = [UsedDeals]()
    private var db = Firestore.firestore()
    func isActive(id: String) -> Bool{
        if usedDeals.contains(where: {$0.id == id}){
            return -usedDeals.first(where: {$0.id == id})!.activated.dateValue().timeIntervalSinceNow < 15*60
        }
        return false
    }
    func isExpired(id: String) -> Bool{
        if usedDeals.contains(where: {$0.id == id}){
            return -usedDeals.first(where: {$0.id == id})!.activated.dateValue().timeIntervalSinceNow > 15*60
        }
        return false
    }
    func useDeal(id: String){
        db.collection("users").document("22iTqJ6JffGl8Qsygp9M").collection("used_deals").document(id).setData([
            "activated": Date()
        ])
    }
    func getTime(id: String) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: usedDeals.first(where: {$0.id == id})!.activated.dateValue().advanced(by: 15*60))
        return dateString
    }
    func fetchData() {
        db.collection("users").document("22iTqJ6JffGl8Qsygp9M").collection("used_deals").getDocuments(){ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.usedDeals = documents.map { (queryDocumentSnapshot) -> UsedDeals in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let activated = data["activated"] as? Timestamp
                return UsedDeals(id:id, activated: activated!)
            }
        }
    }
}
