//
//  SearchView.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI

struct SearchView: View {

    @Environment(\.presentationMode) var presentation

    @ObservedObject var viewModel = CitySearchViewModel()

    var body: some View {
        ScrollView {
            searchBar

            city
        }
    }

    var city: some View {
        Group {
            if let city = viewModel.city  {
                CityCell(city: city)
                    .onTapGesture {
                        addToFavourites()
                    }
            }
        }
        .padding()
    }

    var searchBar: some View {
        SearchBarView(searchQuery: $viewModel.query)
            .padding()
    }
}

private extension SearchView {

    func addToFavourites() {
        guard let city = viewModel.city else {
            return
        }

        DefaultSettings.shared.addId(id: "\(city.id)")
        
        presentation.wrappedValue.dismiss()
    }
}
