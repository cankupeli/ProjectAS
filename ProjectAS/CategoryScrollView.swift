//
//  CategoryScrollView.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-03-28.
//

import SwiftUI

struct CategoryItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("hello")
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem()
    }
}
