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
    @State private var notFirstLoad: Bool = true
    @State var currentPlace: Company?
    init(){
        self.company_ViewModel.fetchData()
    }
    var body: some View {
        NavigationStack{
            ZStack{
                Map(coordinateRegion: $map_ViewModel.region,
                    showsUserLocation: true,
                    annotationItems: company_ViewModel.currentCompanyType,
                    annotationContent: { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)){
                        Button{
                            if (!company_ViewModel.calloutStatus || currentPlace?.id == item.id){
                                company_ViewModel.calloutStatus.toggle()
                            }
                            currentPlace = item
                        }
                        label: {
                            B(companyType: item.categories)
                        }
                    }
                }).task {
                    if (notFirstLoad){
                        notFirstLoad.toggle()
                        await self.map_ViewModel.checkIfLocationServicesIsEnabled()
                    }
                }.onAppear{
                    /*if (notFirstLoad){
                        notFirstLoad.toggle()
                    }*/
                    company_ViewModel.update(companyType: company_ViewModel.companyAll, selectedView: "all")
                }.edgesIgnoringSafeArea(.top)
                    VStack{
                        Menu{
                            Button("All"){
                                if (company_ViewModel.selectedView != "all"){
                                    company_ViewModel.calloutStatus = false
                                    company_ViewModel.update(companyType: company_ViewModel.companyAll, selectedView: "all")
                                }
                            }
                            Button(" Food"){
                                if (company_ViewModel.selectedView != "food"){
                                    company_ViewModel.calloutStatus = false
                                    company_ViewModel.update(companyType: company_ViewModel.companyFood, selectedView: "food")
                                }
                            }
                            Button(" Shopping"){
                                if (company_ViewModel.selectedView != "shopping"){
                                    company_ViewModel.calloutStatus = false
                                    company_ViewModel.update(companyType: company_ViewModel.companyShopping, selectedView: "shopping")
                                }
                            }
                            Button(" Service"){
                                if (company_ViewModel.selectedView != "service"){
                                    company_ViewModel.calloutStatus = false
                                    company_ViewModel.update(companyType: company_ViewModel.companyService, selectedView: "service")
                                }
                            }
                            Button(" Activities"){
                                if (company_ViewModel.selectedView != "activities"){
                                    company_ViewModel.calloutStatus = false
                                    company_ViewModel.update(companyType: company_ViewModel.companyActivities, selectedView: "activities")
                                }
                            }
                        } label: {
                            Image(systemName: "filemenu.and.selection")
                            Text("Showing: \(company_ViewModel.selectedView.capitalized)").bold()
                        }.buttonStyle(.plain).padding().background(.white .opacity(0.8)).frame(alignment: .topLeading).cornerRadius(20)
                        Spacer()
                        if(company_ViewModel.calloutStatus){
                            mapCallout(currentPlace: currentPlace!, callOutStatus: $company_ViewModel.calloutStatus)
                        }
                    }
                }
        }.tabItem{
            Image(systemName: "map.fill")
            Text("Discover")
        }
    }
}
