//
//  ContentView.swift
//  ProjectAS
//
//  Created by Eric Johansson on 2023-02-07.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = userViewModel()
    var body: some View {
        VStack{
            VStack{
                Text("You are currently exploring")
                Button{
                    print("Button tapped")
                } label:{
                    Text("Sundsvall").bold().font(.system(size: 33))
                }
                Text("Lorem Ipsum")
            }
            TabView {
                List(viewModel.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.first).font(.title)
                        Text(user.last).font(.headline)
                    }
                }.navigationBarTitle("Users")
                    .onAppear() {
                        self.viewModel.fetchData()
                    }.tabItem{
                    Image(systemName: "fork.knife.circle.fill")
                    Text("Food")
                }
                Text("Shopping").tabItem{
                    Image(systemName: "cart.fill")
                    Text("Shopping")
                }
                Text("Service").tabItem{
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Service")
                }
                Text("Entertainment").tabItem{
                    Image(systemName: "basketball.fill")
                    Text("Entertainment")
                }
                Text("Profile").tabItem{
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


