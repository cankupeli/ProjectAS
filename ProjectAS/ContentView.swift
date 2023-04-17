//
//  ContentView.swift
//  ProjectAS
//
//

import SwiftUI
import MapKit

struct Companydeals: View {
    @ObservedObject private var companyDeals_ViewModel = companyDealsViewModel()
    var CompanyID = ""
    init(CompanyID: String){
        self.companyDeals_ViewModel.fetchData(company: CompanyID)
    }
    var body: some View{
        Text("Welcome to \(CompanyID)")
    }
}
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
struct mapCallout: View {
  @State private var showTitle = false
    var companyName: String
  var body: some View {
      VStack{
          Text("Sundsvall").font(.title).bold()
          Spacer()
          VStack {
              HStack {
                  VStack(alignment: .leading) {
                      Image(systemName: "xmark").frame(maxWidth: .infinity, alignment: .trailing)
                      Text("\(companyName)")
                          .font(.title)
                          .fontWeight(.black)
                          .foregroundColor(.primary)
                          .lineLimit(3)
                      Text("American burgers, served fresh!".uppercased())
                          .font(.caption)
                          .foregroundColor(.secondary)
                      NavigationLink(destination: EmptyView()) {
                              Text("See Coupons")
                                  .bold()
                                  .padding()
                                  .foregroundColor(.black)
                                  .background(.black         .opacity(0.1))
                                  .cornerRadius(15)
                                  .frame(maxWidth: .infinity, alignment: .center)
                      }
                  }
                  .layoutPriority(100)
                  Spacer()
              }.padding()
          }.background(.white.opacity(0.8))
                  .cornerRadius(15)
                  .padding([.top, .horizontal, .bottom])
      }
  }
}
struct discoveryPage: View {
    @StateObject private var map_ViewModel = mapViewModel()
    @ObservedObject private var company_ViewModel = companyViewModel()
    @State private var companyCoordinates: [Company] = []
    @State private var clickedStatus = false;
    @State private var clickedCompany = "";
    init(){
        self.company_ViewModel.fetchData(category: "food")
        self.companyCoordinates = company_ViewModel.company
    }
    var body: some View {
            NavigationStack{
                ZStack{
                    Map(coordinateRegion: $map_ViewModel.region,
                        showsUserLocation: true,
                        annotationItems: companyCoordinates,
                        annotationContent: { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)){
                            Button {
                                if (clickedCompany == item.name){
                                    clickedCompany = ""
                                    clickedStatus = false
                                }
                                else{
                                    clickedCompany = item.name
                                    clickedStatus = true
                                }
                            } label: {
                                Image(systemName: "mappin").symbolRenderingMode(.hierarchical).foregroundStyle(.red)
                            }
                        }
                    }).edgesIgnoringSafeArea(.top).onAppear{
                        self.map_ViewModel.checkIfLocationServicesIsEnabled()
                        self.company_ViewModel.fetchData(category: "food")
                        self.companyCoordinates = company_ViewModel.company}
                    if (clickedStatus){mapCallout(companyName: clickedCompany)}
                }
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }
    }
}
struct companyView: View {
    @ObservedObject private var location_ViewModel = locationViewModel()
    @ObservedObject private var company_ViewModel = companyViewModel()
    @State private var path = NavigationPath()
    @State private var locationChangerButton = false
    var category = ""
    var logo = ""
    init(category: String, logo: String){
        self.company_ViewModel.fetchData(category: category)
        self.category = category
        self.logo = logo
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
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
                            Text("License Agreement")
                                .font(.title)
                                .padding(50)
                            Text("""
                                Terms and conditions go here.
                            """)
                            .padding(50)
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
                List(company_ViewModel.company) { company in
                    NavigationLink(destination: Companydeals(CompanyID: company.id)) {
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
