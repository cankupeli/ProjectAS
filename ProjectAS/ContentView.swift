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
        NavigationView {
            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.first).font(.title)
                    Text(user.last).font(.headline)
                }
            }.navigationBarTitle("Users")
                .onAppear() {
                    self.viewModel.fetchData()
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
