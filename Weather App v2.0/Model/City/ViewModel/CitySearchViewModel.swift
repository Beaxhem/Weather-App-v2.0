//
//  CitySearchViewModel.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI
import Combine

class CitySearchViewModel: ObservableObject {

    @Published var city: WeatherModel?

    @Published var query: String = ""

    private let weatherService: WeatherService
    private var cancellable = Set<AnyCancellable>()

    init(weatherService: WeatherService = WeatherManager()) {
        self.weatherService = weatherService

        setupQuery()
    }
}



private extension CitySearchViewModel {

    func setupQuery() {

        let scheduler = DispatchQueue(label: "com.beaxhem.Weather-App-v2.0.citySearch")

        $query
            .dropFirst()
            .debounce(for: 1, scheduler: scheduler)
            .flatMap { [weak self] query -> AnyPublisher<WeatherModel, Error> in
                guard let self = self else {
                    return Fail(outputType: WeatherModel.self, failure: URLError.badURL).eraseToAnyPublisher()
                }

                return self.search(query: query)
            }
            .receive(on: RunLoop.main)
            .retry(.max)
            .sink { status in
                switch status {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                }
            } receiveValue: { city in
                self.city = city
            }
            .store(in: &cancellable)

    }

    func search(query: String) -> AnyPublisher<WeatherModel, Error> {
        weatherService.loadCurrentWeather(byCityname: query)
    }
}
