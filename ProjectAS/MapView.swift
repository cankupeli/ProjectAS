//
//  MapView.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-17.
//

import Foundation
import SwiftUI
import MapKit

struct mapCallout: View {
    var currentPlace: Company
    @Binding var callOutStatus: Bool
    var body: some View {
      VStack{
          Spacer()
              VStack {
                  HStack {
                      VStack(alignment: .leading) {
                          Button{
                              callOutStatus.toggle()
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
                                      //.foregroundColor(.black)
                                      //.background(.black         .opacity(0.1))
                                      .cornerRadius(15)
                                      .frame(maxWidth: .infinity, alignment: .center)
                          }
                          //.buttonStyle(.bordered)
                          .buttonStyle(.borderedProminent)
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
    @State private var callOutStatus: Bool = false
    @State private var notFirstLoad: Bool = true
    @State var currentPlace: Company?
    @State private var companyCoordinates: [Company] = []
    @State private var currentType : String = "All"
    init(){
        self.company_ViewModel.fetchData()
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
                            if (!callOutStatus || currentPlace?.id == item.id){
                                callOutStatus.toggle()
                            }
                            currentPlace = item
                        }
                        label: {
                            B(companyType: item.categories)
                        }
                    }
                }).onAppear{
                    if (notFirstLoad){
                        notFirstLoad.toggle()
                        self.map_ViewModel.checkIfLocationServicesIsEnabled()
                    }
                    self.companyCoordinates = company_ViewModel.companyAll
                    currentType = "all"
                }.edgesIgnoringSafeArea(.top)
                    VStack{
                        Menu{
                            Button("All"){
                                if (currentType != "all"){
                                    callOutStatus = false
                                }
                                currentType = "all"
                                self.companyCoordinates = company_ViewModel.companyAll
                            }
                            Button(" Food"){
                                if (currentType != "food"){
                                    callOutStatus = false
                                }
                                currentType = "food"
                                self.companyCoordinates = company_ViewModel.companyFood
                            }
                            Button(" Shopping"){
                                if (currentType != "shopping"){
                                    callOutStatus = false
                                }
                                currentType = "shopping"
                                self.companyCoordinates = company_ViewModel.companyShopping
                            }
                            Button(" Service"){
                                if (currentType != "service"){
                                    callOutStatus = false
                                }
                                currentType = "service"
                                self.companyCoordinates = company_ViewModel.companyService
                            }
                            Button(" Activities"){
                                if (currentType != "activities"){
                                    callOutStatus = false
                                }
                                currentType = "activities"
                                self.companyCoordinates = company_ViewModel.companyActivities
                            }
                        } label: {
                            Image(systemName: "filemenu.and.selection")
                            Text("Showing: \(currentType.capitalized)").bold()
                        }.buttonStyle(.plain).padding().background(.white .opacity(0.8)).frame(alignment: .topLeading).cornerRadius(20)
                        Spacer()
                        if (callOutStatus){
                            mapCallout(currentPlace: currentPlace!, callOutStatus: $callOutStatus)
                        }
                    }
                }
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }
    }
}
