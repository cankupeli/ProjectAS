//
//  companyDealsView.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-17.
//

import Foundation
import SwiftUI
struct Companydeals: View {
    @ObservedObject private var companyDeals_ViewModel = companyDealsViewModel()
    var currentPlace: Company
    var body: some View{
        VStack{
            Text("Welcome to \(currentPlace.name)")
            NavigationStack{
                List(companyDeals_ViewModel.companyDeals) { CompanyDeals in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(CompanyDeals.title).font(.title)
                                Text(CompanyDeals.description).font(.headline)
                            }
                            Spacer()
                            VStack(){
                                Text("3").font(.title)
                                Text("Coupons")
                            }
                    }
                }
            }
        }.onAppear{
            self.companyDeals_ViewModel.fetchData(company: currentPlace.id)
            
        }
    }
}
