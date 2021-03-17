//
//  CitiesViewModel.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 14.03.2021.
//

import SwiftUI
import Combine

class CitiesViewModel: ObservableObject {

    @Published var cities = [WeatherModel]()

    private let weatherService: WeatherService

    private var cancellable = Set<AnyCancellable>()

    init(weatherService: WeatherService = WeatherManager()) {
        self.weatherService = weatherService

        fetchCities()
    }

    func fetchCities(){
        guard let citiesIDs = UserDefaults.standard.stringArray(forKey: "cities") else {
            return
        }

        weatherService.loadCurrentWeatherForMultipleCities(citiesIDs: citiesIDs)
            .receive(on: RunLoop.main)
            .sink { status in
                switch status {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                }
            } receiveValue: { cities in
                self.cities = cities
            }
            .store(in: &cancellable)
    }
}


