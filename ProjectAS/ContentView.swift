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
                }
            }
        }
    }
}
struct companyView: View {
    @EnvironmentObject private var location_ViewModel: locationViewModel
    @EnvironmentObject private var company_ViewModel: companyViewModel
    @State private var locationChangerButton = false
    private var category = ""
    private var logo = ""
    init(category: String, logo: String){
        self.category = category
        self.logo = logo
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
                            CategoryListItem(Categorytype: "Café").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Fine Dinning").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Takeaway").shadow(radius: 5)
                            CategoryListItem(Categorytype: "Restaurant").shadow(radius: 5)
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
    @ObservedObject private var company_ViewModel = companyViewModel()
    @ObservedObject private var location_ViewModel = locationViewModel()
    init(){
        company_ViewModel.fetchData()
        location_ViewModel.fetchData()
    }
    var body: some View {
            TabView {
                companyView(category: "food", logo: "fork.knife")
                companyView(category: "shopping", logo: "cart.fill")
                discoveryPage()
                companyView(category: "service", logo: "fuelpump.fill")
                companyView(category: "activities", logo: "basketball.fill")
            }.environmentObject(company_ViewModel).environmentObject(location_ViewModel)
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
