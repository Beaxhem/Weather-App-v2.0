//
//  DetailedWeatherViewModel.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import SwiftUI
import Combine

class DetailedWeatherViewModel: ObservableObject {

    @Published var predictions = [Prediction]()

    private let weatherService: WeatherService

    private var cancellable = Set<AnyCancellable>()

    init(weatherService: WeatherService = WeatherManager()) {
        self.weatherService = weatherService
    }

    func fetchPredictions(coords: Coords) {
        weatherService.loadWeatherPrediction(coords: coords)
            .receive(on: RunLoop.main)
            .map { $0.daily }
            .sink { status in
                switch status {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                }
            } receiveValue: { predictions in
                self.predictions = predictions
            }
            .store(in: &cancellable)
    }
}
