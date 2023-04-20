//
//  companyDealsView.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-17.
//

import Foundation
import SwiftUI
import SwiftUI
struct sheetView: View{
    @Environment(\.dismiss) var dismiss
    @State var currentDeal: CompanyDeals
    var body: some View{
        VStack {
            Button{
                dismiss()
            }
            label:{
                Image(systemName: "xmark").frame(maxWidth: .infinity, alignment: .trailing).foregroundStyle(.black).font(.system(size: 20, weight: .heavy))
            }.padding(20)
            VStack(alignment: .center) {
                Text(currentDeal.title).font(.title).fixedSize(horizontal: false, vertical: true).fontWeight(.black)
                Text(currentDeal.description).fixedSize(horizontal: false, vertical: true).font(.caption).padding(5)
            }
            Spacer()
            Button{
                dismiss()
            }
            label:{
                Text("Active Me!").font(.system(size: 25, weight: .heavy))
                    .bold()
                    .padding()
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.horizontal, 20).buttonStyle(.borderedProminent).tint(Color("ApplicationColour"))
        }.presentationDetents([.medium, .fraction(0.4)]).presentationDragIndicator(.hidden)
        Text("*Once activated, you'll have 15 minutes to use the coupon before it becomes automatically used").font(.system(size: 13)).italic().padding(5)
    }
}
struct Companydeals: View {
    @ObservedObject private var companyDeals_ViewModel = companyDealsViewModel()
    @State private var dealChangerButton = false
    @State var currentDeal: CompanyDeals?
    var currentPlace: Company
    var body: some View{
        VStack(spacing: 0){
            VStack{
                Text("\(currentPlace.name)").foregroundColor(.white).font(.title).bold()
                Text("\(currentPlace.address)").foregroundColor(.white).font(.caption2)
                Text("\(currentPlace.description)").foregroundColor(.white).font(.body).padding(.horizontal, 7)
            }.padding(.bottom, 20).frame(maxWidth: .infinity).background(Color("ApplicationColour"))
            NavigationStack{
                List(companyDeals_ViewModel.companyDeals) { CompanyDeals in
                    Button{
                        dealChangerButton.toggle()
                        currentDeal = CompanyDeals
                    } label:{
                        HStack{
                            if (CompanyDeals.type == "free"){
                                VStack(spacing: -5){
                                    Text("F").foregroundColor(.white).fontWeight(.black).bold()
                                    Text("R").foregroundColor(.white).fontWeight(.black).bold()
                                    Text("E").foregroundColor(.white).fontWeight(.black).bold()
                                    Text("E").foregroundColor(.white).fontWeight(.black).bold()
                                }.padding(7).background(Color("ApplicationColour")).cornerRadius(10)
                            }
                            else if(CompanyDeals.type == "2for1"){
                                VStack{
                                    Text("2").foregroundColor(.white).font(.title).bold()
                                    Text("For").foregroundColor(.white).font(.body).italic()
                                    Text("1").foregroundColor(.white).font(.title).bold()
                                }.padding(2).background(Color("ApplicationColour")).cornerRadius(20)
                            }
                            else{
                                VStack(spacing: 0){
                                    Text(String(CompanyDeals.type.dropLast())).foregroundColor(.white).font(.title).fontWeight(.black)
                                    Text("%").foregroundColor(.white).font(.system(size: 36)).fontWeight(.black)
                                }.padding(.vertical, 8).padding(.horizontal, 5).background(Color("ApplicationColour")).cornerRadius(10)
                            }
                            VStack(alignment: .leading) {
                                Text(CompanyDeals.title).font(.title)
                                Text(CompanyDeals.description).font(.caption)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }.buttonStyle(.plain)
                }
            }
        }.sheet(item: $currentDeal){ currentDeal in
            sheetView(currentDeal: currentDeal).presentationDetents([ .fraction(0.4)]).presentationDragIndicator(.hidden)

        }.onAppear{
            self.companyDeals_ViewModel.fetchData(company: currentPlace.id)
        }
    }
}
