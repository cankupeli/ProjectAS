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
        VStack(spacing: 0){

            VStack{
                Text("\(currentPlace.name)").font(.title).bold()
                Text("\(currentPlace.address)").font(.caption2)
                Text("\(currentPlace.description)").font(.body)
            }.padding(.bottom, 10).frame(maxWidth: .infinity).background(.yellow)
            NavigationStack{
                List(companyDeals_ViewModel.companyDeals) { CompanyDeals in
                    HStack{
                        /*VStack{
                            Text("DISCOUNT").font(.body).bold()
                        }.padding(5).background(.yellow).cornerRadius(20).rotationEffect(.degrees(-90))*/
                        VStack{
                            Text("2").font(.title).bold()
                            Text("For").font(.body).italic()
                            Text("1").font(.title).bold()
                        }.background(.yellow).cornerRadius(20)
                        VStack(alignment: .leading) {
                            Text(CompanyDeals.title).font(.title)
                            Text(CompanyDeals.description).font(.headline)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }.onAppear{
            self.companyDeals_ViewModel.fetchData(company: currentPlace.id)
            
        }
    }
}
