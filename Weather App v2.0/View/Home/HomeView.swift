//
//  ContentView.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 14.03.2021.
//

import SwiftUI

struct HomeView: View {

    @State var isSearchPresented = false

    @ObservedObject var currentPositionViewModel = CurrentLocationWeatherViewModel()
    @ObservedObject var viewModel =  CitiesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                localWeather

                citiesList
            }
            .navigationTitle("Cities")
            .navigationBarItems(
                trailing: Button(action: {
                    isSearchPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }))
        }
        .sheet(isPresented: $isSearchPresented, onDismiss: {
            viewModel.fetchCities()
        }, content: {
            SearchView()
        })
    }

    var localWeather: some View {
        Group {
            if let weather = currentPositionViewModel.localWeather {
                NavigationLink(destination: DetailedWeatherView(city: weather)) {
                    CityCell(city: weather)
                        .padding()
                        .foregroundColor(.white)
                }
            }
        }
    }

    var citiesList: some View {
        LazyVStack {
            ForEach(viewModel.cities) { city in
                NavigationLink(destination: DetailedWeatherView(city: city)) {
                    CityCell(city: city)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.top, 1)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
