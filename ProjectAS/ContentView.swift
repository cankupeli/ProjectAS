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
                    Image(systemName: "laurel.trailing").renderingMode(.original).foregroundStyle(.green).font(.system(size: 25, weight: .black))
                }
                    .frame(width: 100, height: 90)
                    .background(Color("ApplicationColour")).cornerRadius(20)
                Text("\(Categorytype.capitalized)")
                    .font(.subheadline)
                
            }
            .padding(.leading, 10)}
            else{
            VStack(alignment: .center) {
                HStack{
                    Image(systemName: "laurel.leading").renderingMode(.original).foregroundStyle(.white).font(.system(size: 25, weight: .black))
                    Image(systemName: "laurel.trailing").renderingMode(.original).foregroundStyle(.white).font(.system(size: 25, weight: .black))
                }
                    .frame(width: 100, height: 90)
                    .background(Color("ApplicationColour")).cornerRadius(20)
                Text("\(Categorytype.capitalized)")
                    .font(.subheadline)
                
            }
            .padding(.leading, 10)}
            
        }.buttonStyle(PlainButtonStyle())
    }
}
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
        }.listStyle(.plain)
    }
}
struct companyView: View {
    @EnvironmentObject private var location_ViewModel: locationViewModel
    @EnvironmentObject private var company_ViewModel: companyViewModel
    @EnvironmentObject private var map_ViewModel: mapViewModel
    @EnvironmentObject private var usedDeals_ViewModel: usedDealsViewModel
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
                        Text(location_ViewModel.currentLocation.name).foregroundColor(.white).bold().font(.system(size: 28)).padding(8).overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 2)
                        )
                        
                    }.sheet(isPresented: $locationChangerButton){
                        
                        VStack{
                            Text("Locations").font(.body).bold().frame(maxWidth: .infinity, alignment: .center).padding(.horizontal, 15).padding(.top, 15)
                            List(location_ViewModel.locations){ item in
                                Button{
                                    locationChangerButton.toggle()
                                    location_ViewModel.update(place: item.name)
                                    company_ViewModel.fetchData(location: location_ViewModel.currentLocation.id)
                                    map_ViewModel.region = MKCoordinateRegion(
                                                center: CLLocationCoordinate2D(
                                                    latitude: item.location.latitude,
                                                    longitude: item.location.longitude),
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.09,
                                                    longitudeDelta: 0.04)
                                                )
                                    company_ViewModel.calloutStatus = false
                                }label:{
                                    Text(item.name)
                                            .bold()
                                            .padding()
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .frame(maxWidth: .infinity, alignment: .center).buttonStyle(.plain).background(Color("ApplicationColour")).cornerRadius(50).padding(.horizontal, 40)
                                }.listRowSeparator(.hidden).padding(.vertical, -4)
                            }.listStyle(.plain)
                        }.presentationDetents([.fraction(0.3)]).presentationDragIndicator(.visible)
                    }
                    Text(location_ViewModel.currentLocation.description).foregroundColor(.white).font(.headline).padding(8)
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
                else if (category == "shopping"){
                    companyList(currentType: company_ViewModel.companyShopping, filter: $filter)
                }
                else if (category == "service"){
                    companyList(currentType: company_ViewModel.companyService, filter: $filter)
                }
                else if (category == "activities"){
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
    @ObservedObject private var map_ViewModel = mapViewModel()
    @ObservedObject private var usedDeals_ViewModel = usedDealsViewModel()
    init(){
        company_ViewModel.fetchData(location: location_ViewModel.currentLocation.id)
        location_ViewModel.fetchData()
        usedDeals_ViewModel.fetchData()
    }
    var body: some View {
            TabView {
                companyView(category: "food", filterCollection: ["cafe","fine dining","takeaway","restaurant"], logo: "fork.knife")
                companyView(category: "shopping", filterCollection: ["groceries","clothes","hobby", "electronics"], logo: "cart.fill")
                discoveryPage()
                companyView(category: "service", filterCollection: ["house","mechanic","pets"], logo: "fuelpump.fill")
                companyView(category: "activities", filterCollection: ["sports", "events"], logo: "basketball.fill")
            }.environmentObject(company_ViewModel).environmentObject(location_ViewModel).environmentObject(map_ViewModel).environmentObject(usedDeals_ViewModel)
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
