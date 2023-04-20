//
//  ContentView.swift
//  ProjectAS
//
//

import SwiftUI
import MapKit


struct CategoryListItem: View{
    let Categorytype: String
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            VStack(alignment: .center) {
                Image("\(Categorytype)")
                    .resizable()
                    .frame(width: 100, height: 90)
                    .cornerRadius(5)
                Text("\(Categorytype)")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct companyList: View{
    let currentType : [Company]
    var body: some View {
        List(currentType) { company in
            NavigationLink(destination: Companydeals(currentPlace: company)) {
                HStack{
                    VStack(alignment: .leading) {
                        Text(company.name).font(.title)
                        Text(company.address).font(.headline)
                    }
                    Spacer()
                    VStack(){
                        Text("3").font(.title)
                        Text("Coupons")
                    }
                }
            }
        }
    }
}
struct companyView: View {
    @ObservedObject private var location_ViewModel = locationViewModel()
    @ObservedObject private var company_ViewModel = companyViewModel()
    @State private var path = NavigationPath()
    @State private var locationChangerButton = false
    @State private var currentType : [Company] = []
    private var category = ""
    private var logo = ""
    init(category: String, logo: String){
        self.company_ViewModel.fetchData()
        self.category = category
        self.logo = logo
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                /*
                 VStack{
                     Text("You are currently exploring").foregroundColor(.white)
                     Button{
                         locationChangerButton.toggle()
                     } label:{
                         Text("Sundsvall").foregroundColor(.white).bold().font(.system(size: 28)).padding(8).overlay(
                             RoundedRectangle(cornerRadius: 16)
                                 .stroke(.blue, lineWidth: 2)
                         )
                     }.sheet(isPresented: $locationChangerButton){
                         VStack {
                             Button("Dismiss",
                                    action: { locationChangerButton.toggle() })
                         }.presentationDetents([.large, .medium, .fraction(0.6)])
                     }
                     Text(location_ViewModel.currentLocation.description).foregroundColor(.white).font(.headline).lineLimit(4).padding(8).onAppear() {
                         self.location_ViewModel.fetchData()
                     }
                 }.frame(maxWidth: .infinity).padding(0).background(Color("ApplicationColour"))
                 VStack(alignment: .leading) {
                     Text("Categories")
                         .font(.headline)
                         .padding(.leading, 15)
                         .padding(.top, 5)
                     ScrollView(.horizontal, showsIndicators: false) {
                         HStack(alignment: .top, spacing: 0) {
                             CategoryListItem(Categorytype: "Burger").shadow(radius: 5)
                             CategoryListItem(Categorytype: "Pizza").shadow(radius: 5)
                             CategoryListItem(Categorytype: "Sushi").shadow(radius: 5)
                             CategoryListItem(Categorytype: "Mexican").shadow(radius: 5)
                         }
                     }
                     .frame(height: 120)
                 }
                 */
                VStack{
                    Text("You are currently exploring")
                    Button{
                        locationChangerButton.toggle()
                    } label:{
                        Text("Sundsvall").bold().font(.system(size: 28)).padding(8).overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.blue, lineWidth: 2)
                        )
                    }.sheet(isPresented: $locationChangerButton){
                        VStack {
                            Button("Dismiss",
                                   action: { locationChangerButton.toggle() })
                        }.presentationDetents([.large, .medium, .fraction(0.6)])
                    }
                    Text(location_ViewModel.currentLocation.description).font(.headline).lineLimit(4).padding(8).onAppear() {
                        self.location_ViewModel.fetchData()
                    }
                }
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.headline)
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            CategoryListItem(Categorytype: "Burger").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Pizza").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Sushi").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Mexican").shadow(radius: 5)
                        }
                    }
                    .frame(height: 120)
                }
                if (category == "food"){
                    companyList(currentType: company_ViewModel.companyFood)
                }
                if (category == "shopping"){
                    companyList(currentType: company_ViewModel.companyShopping)
                }
                if (category == "service"){
                    companyList(currentType: company_ViewModel.companyService)
                }
                if (category == "activities"){
                    companyList(currentType: company_ViewModel.companyActivities)
                }
            }
        }.tabItem{
            Image(systemName: self.logo)
            Text(self.category.capitalized)
        }
    }
}
struct ContentView: View {
    var body: some View {
            TabView {
                companyView(category: "food", logo: "fork.knife")
                companyView(category: "shopping", logo: "cart.fill")
                discoveryPage()
                companyView(category: "service", logo: "fuelpump.fill")
                companyView(category: "activities", logo: "basketball.fill")
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
