//
//  SearchBar.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var searchQuery: String

    var body: some View {
        TextField("Search", text: $searchQuery)
            .padding(5)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}
