//
//  ContentView.swift
//  ProjectAS
//
//

import SwiftUI
import MapKit


struct CategoryListItem: View{
    let Categorytype: String
    @Binding var filter: String
    var body: some View {
        Button{
            if (filter != Categorytype){
                filter = Categorytype
            }
            else{
                filter = "all"
            }
        } label:{
            if (Categorytype == filter){
            VStack(alignment: .center) {
                HStack{
                    Image(systemName: "laurel.leading").renderingMode(.original).foregroundStyle(.green).font(.system(size: 25, weight: .black))
                    Image(systemName: "laurel.trailing").renderingMode(.original).foregroundStyle(.blue).font(.system(size: 25, weight: .black))
                }
                    .frame(width: 100, height: 90)
                    .background(Color("ApplicationColour")).cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4)
                    )
                Text("\(Categorytype.capitalized)")
                    .font(.subheadline)
                
            }
            .padding(.leading, 10)}
            else{
            VStack(alignment: .center) {
                HStack{
                    Image(systemName: "laurel.leading").renderingMode(.original).foregroundStyle(.green).font(.system(size: 25, weight: .black))
                    Image(systemName: "laurel.trailing").renderingMode(.original).foregroundStyle(.blue).font(.system(size: 25, weight: .black))
                }
                    .frame(width: 100, height: 90)
                    .background(Color("ApplicationColour")).cornerRadius(20)
                Text("\(Categorytype.capitalized)")
                    .font(.subheadline)
                
            }
            .padding(.leading, 10)}
            
        }.buttonStyle(PlainButtonStyle())
        /*
        NavigationLink(destination: EmptyView()) {
            VStack(alignment: .center) {
                HStack{
                    Image(systemName: "laurel.leading").renderingMode(.original).foregroundStyle(.green).font(.system(size: 25, weight: .black))
                    Image(systemName: "laurel.trailing").renderingMode(.original).foregroundStyle(.blue).font(.system(size: 25, weight: .black))
                }
                    .frame(width: 100, height: 90)
                    .background(Color("ApplicationColour")).cornerRadius(20)
                Text("\(Categorytype)")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
        }.buttonStyle(PlainButtonStyle())*/
    }
}
/*
 restaurant
 takeaway
 cafe
 */
struct companyList: View{
    let currentType : [Company]
    @Binding var filter: String
    var body: some View {
        List(currentType) { company in
            if (company.type == filter || filter == "all"){
                NavigationLink(destination: Companydeals(currentPlace: company)) {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(company.name).font(.title)
                            Text(company.address).font(.headline)
                        }
                    }
                }
            }
        }
    }
}
struct companyView: View {
    @EnvironmentObject private var location_ViewModel: locationViewModel
    @EnvironmentObject private var company_ViewModel: companyViewModel
    @State private var filter = "all"
    @State private var locationChangerButton = false
    @State private var filterCollection : [String]
    private var category = ""
    private var logo = ""
    init(category: String, filterCollection: [String], logo: String){
        self.category = category
        self.logo = logo
        self.filterCollection = filterCollection
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                VStack{
                    Text("You are currently exploring").foregroundColor(.white).font(.caption).italic()
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
                    Text(location_ViewModel.currentLocation.description).foregroundColor(.white).font(.headline).lineLimit(4).padding(8)
                }.frame(maxWidth: .infinity).padding(.bottom, 10).background(Color("ApplicationColour"))
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.headline)
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(filterCollection, id: \.self) { item in
                                CategoryListItem(Categorytype: item, filter: $filter)
                            }
                            /*CategoryListItem(Categorytype: "cafe", filter: $filter)
                            CategoryListItem(Categorytype: "fine Dinning", filter: $filter)
                            CategoryListItem(Categorytype: "takeaway", filter: $filter)
                            CategoryListItem(Categorytype: "restaurant", filter: $filter)*/
                        }
                    }
                    .frame(height: 120)
                    VStack(alignment: .leading) {
                        Text(filter.capitalized)
                            .font(.headline)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                    }
                }
                if (category == "food"){
                    companyList(currentType: company_ViewModel.companyFood, filter: $filter)
                }
                if (category == "shopping"){
                    companyList(currentType: company_ViewModel.companyShopping, filter: $filter)
                }
                if (category == "service"){
                    companyList(currentType: company_ViewModel.companyService, filter: $filter)
                }
                if (category == "activities"){
                    companyList(currentType: company_ViewModel.companyActivities, filter: $filter)
                }
            }
        }.tabItem{
            Image(systemName: self.logo)
            Text(self.category.capitalized)
        }
    }
}
struct ContentView: View {
    @ObservedObject private var company_ViewModel = companyViewModel()
    @ObservedObject private var location_ViewModel = locationViewModel()
    init(){
        company_ViewModel.fetchData()
        location_ViewModel.fetchData()
    }
    var body: some View {
            TabView {
                companyView(category: "food", filterCollection: ["cafe","fine dinning","takeaway","restaurant"], logo: "fork.knife")
                companyView(category: "shopping", filterCollection: ["Groceries","Clothes","Hobby", "Electronics"], logo: "cart.fill")
                discoveryPage()
                companyView(category: "service", filterCollection: ["House","Mechanic","Pets"], logo: "fuelpump.fill")
                companyView(category: "activities", filterCollection: ["Sports", "Events"], logo: "basketball.fill")
            }.environmentObject(company_ViewModel).environmentObject(location_ViewModel)
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
