//
//  MapView.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-17.
//

import Foundation
import SwiftUI
import MapKit


/*struct A: View {
    let companyID: String
    var body: some View {
        Menu {
            NavigationLink(destination: Companydeals(CompanyID: companyID)) {
                Text("Mcdonalds")
                Text("Great American burgers!")
                Image(systemName: "chevron.right").frame(maxWidth: .infinity, alignment: .trailing)
            }
        } label: {
            Image(systemName: "mappin").symbolRenderingMode(.hierarchical).foregroundStyle(.red).font(.system(size: 20, weight: .black))
        }
    }
}*/
struct mapCallout: View {
    var currentPlace: Company
    //@Binding var currentLocation: String
    @Binding var currentLocation: Bool
    var body: some View {
      VStack{
          Spacer()
              VStack {
                  HStack {
                      VStack(alignment: .leading) {
                          Button{
                              //currentLocation = "NULL"
                              currentLocation.toggle()
                          }
                      label:{
                          Image(systemName: "xmark").frame(maxWidth: .infinity, alignment: .trailing).foregroundStyle(.black).font(.system(size: 20, weight: .heavy))
                      }
                          Text(currentPlace.name)
                              .font(.title)
                              .fontWeight(.black)
                              .foregroundColor(.black)
                              .lineLimit(3)
                          Text(currentPlace.description.uppercased())
                              .font(.caption)
                              .foregroundColor(.secondary)
                          NavigationLink(destination: Companydeals(currentPlace: currentPlace)) {
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

struct B: View {
    let companyType: [String]
    var body: some View {
        switch companyType.count {
            case 1:
                switch companyType.first{
                    case "food":
                        Image(systemName: "fork.knife.circle.fill").renderingMode(.original).foregroundStyle(.green).font(.system(size: 25, weight: .black))
                    case "shopping":
                        Image(systemName: "cart.circle.fill").renderingMode(.original).foregroundStyle(.red).font(.system(size: 25, weight: .black))
                    case "service":
                        Image(systemName: "fuelpump.circle.fill").renderingMode(.original).foregroundStyle(.black).font(.system(size: 25, weight: .black))
                    case "activities":
                        Image(systemName: "basketball.circle.fill").renderingMode(.original).foregroundStyle(.blue).font(.system(size: 25, weight: .black))
                    default:
                        Image(systemName: "timelapse.circle.fill").renderingMode(.original).foregroundStyle(.black).font(.system(size: 20, weight: .black))
                    }
            default:
                Image(systemName: "mappin").symbolRenderingMode(.hierarchical).foregroundStyle(.red).font(.system(size: 20, weight: .black))
        }
    }
}




struct discoveryPage: View {
    @ObservedObject private var map_ViewModel = mapViewModel()
    @ObservedObject private var company_ViewModel = companyViewModel()
    //@State private var currentLocation: String = "NULL"
    @State private var currentLocation: Bool = false
    @State var currentPlace: Company?
    @State private var currentLocationName: String = "NULL"
    @State private var currentLocationDescription: String = "NULL"
    @State private var companyCoordinates: [Company] = []
    @State private var callOut : Bool = false
    @State private var currentType : String = "All"
    init(){
        self.company_ViewModel.fetchData()
        self.companyCoordinates = company_ViewModel.companyFood
    }
    var body: some View {
        NavigationStack{
            ZStack{
                Map(coordinateRegion: $map_ViewModel.region,
                    showsUserLocation: true,
                    annotationItems: companyCoordinates,
                    annotationContent: { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)){
                        Button{
                            //currentLocation = item.id
                            //currentLocationName = item.name
                            if (!currentLocation || currentPlace?.id == item.id){
                                currentLocation.toggle()
                            }
                            //currentLocation.toggle()
                            currentPlace = item
                        }
                        label: {
                            B(companyType: item.categories)
                            /*Image(systemName: "mappin").symbolRenderingMode(.hierarchical).foregroundStyle(.red).font(.system(size: 20, weight: .black))*/
                        }
                    }
                }).onAppear{
                    self.map_ViewModel.checkIfLocationServicesIsEnabled()
                    self.companyCoordinates = company_ViewModel.companyAll
                    currentType = "all"
                }.edgesIgnoringSafeArea(.top)
                    VStack{
                        Menu{
                            Button("All"){
                                if (currentType != "all"){
                                    currentLocation = false
                                }
                                currentType = "all"
                                self.companyCoordinates = company_ViewModel.companyAll
                            }
                            Button(" Food"){
                                if (currentType != "food"){
                                    currentLocation = false
                                }
                                currentType = "food"
                                self.companyCoordinates = company_ViewModel.companyFood
                            }
                            Button(" Shopping"){
                                if (currentType != "shopping"){
                                    currentLocation = false
                                }
                                currentType = "shopping"
                                self.companyCoordinates = company_ViewModel.companyShopping
                            }
                            Button(" Service"){
                                if (currentType != "service"){
                                    currentLocation = false
                                }
                                currentType = "service"
                                self.companyCoordinates = company_ViewModel.companyService
                            }
                            Button(" Activities"){
                                if (currentType != "activities"){
                                    currentLocation = false
                                }
                                currentType = "activities"
                                self.companyCoordinates = company_ViewModel.companyActivities
                            }
                        } label: {
                            Image(systemName: "filemenu.and.selection")
                            Text("Showing: \(currentType.capitalized)").bold()
                        }.buttonStyle(.plain).padding().background(.white .opacity(0.8)).frame(alignment: .topLeading).cornerRadius(20)
                        Spacer()
                        if (currentLocation){
                            mapCallout(currentPlace: currentPlace!, currentLocation: $currentLocation)
                        }
                        /*if (currentLocation != "NULL"){
                            mapCallout(currentPlace: currentPlace!, currentLocation: $currentLocation)
                        }*/
                    }
                }
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }
    }
}





/*struct discoveryPage: View {
    @ObservedObject private var map_ViewModel = mapViewModel()
    @ObservedObject private var company_ViewModel = companyViewModel()
    @State private var currentLocation: String = "NULL"
    @State private var companyCoordinates: [Company] = []
    @State private var callOut : Bool = false
    @State private var currentType : String = "All"
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
                    Button{
                        currentLocation = item.id
                    }
                    label: {
                        Image(systemName: "mappin").symbolRenderingMode(.hierarchical).foregroundStyle(.red).font(.system(size: 20, weight: .black))
                    }
                }
            }).onAppear{
                self.map_ViewModel.checkIfLocationServicesIsEnabled()
                //self.company_ViewModel.fetchData(category: "food")
                //self.companyCoordinates = company_ViewModel.company
            }.edgesIgnoringSafeArea(.top)
                VStack{
                    Menu{
                        Button("All"){
                            currentType = "all"
                            self.company_ViewModel.fetchData(category: "all")
                            self.companyCoordinates = company_ViewModel.company
                        }
                        Button(" Food"){
                            currentType = "food"
                            self.company_ViewModel.fetchData(category: "food")
                            self.companyCoordinates = company_ViewModel.company
                        }
                        Button(" Shopping"){
                            currentType = "shopping"
                            self.company_ViewModel.fetchData(category: "shopping")
                            self.companyCoordinates = company_ViewModel.company
                        }
                        Button(" Service"){
                            currentType = "service"
                            self.company_ViewModel.fetchData(category: "service")
                            self.companyCoordinates = company_ViewModel.company
                        }
                        Button(" Activities"){
                            currentType = "activities"
                            self.company_ViewModel.fetchData(category: "activities")
                            self.companyCoordinates = company_ViewModel.company
                        }
                    } label: {
                        Image(systemName: "filemenu.and.selection")
                        Text("Showing: \(currentType.capitalized)").bold()
                    }.buttonStyle(.plain).padding().background(.white .opacity(0.8)).frame(alignment: .topLeading).cornerRadius(20)
                    Spacer()
                if (currentLocation != "NULL"){
                    mapCallout(companyName: currentLocation, companyID: currentLocation, currentLocation: $currentLocation)
                }
                }
        }
            
            
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }
        /*NavigationStack{
            Map(coordinateRegion: $map_ViewModel.region,
                showsUserLocation: true,
                annotationItems: companyCoordinates,
                annotationContent: { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)){
                    A(companyID: item.name)
                }
            }).edgesIgnoringSafeArea(.top).onAppear{
                self.map_ViewModel.checkIfLocationServicesIsEnabled()
                self.company_ViewModel.fetchData(category: "food")
                self.companyCoordinates = company_ViewModel.company}
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }*/
    }
}*/
