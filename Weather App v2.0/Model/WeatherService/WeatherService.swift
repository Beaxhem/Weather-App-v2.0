//
//  WeatherService.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 16.03.2021.
//

import SwiftUI
import Combine
import CoreLocation

protocol WeatherService {
    func loadCurrentWeather(byCityname city: String) -> AnyPublisher<WeatherModel, Error>
    func loadCurrentWeather(coords: CLLocationCoordinate2D) -> AnyPublisher<WeatherModel, Error>

    func loadCurrentWeatherForMultipleCities(citiesIDs: [String]) -> AnyPublisher<[WeatherModel], Error>

    func loadWeatherPrediction(coords: Coords) -> AnyPublisher<PredictionQuery, Error>
}

enum URLError: Error {
    case badURL
}

class WeatherManager: WeatherService {

    static let shared = WeatherManager()

    var urlProvider: URLProvider
    var jsonDecoder = JSONDecoder()

    init(urlProvider: URLProvider = OpenWeatherURLProvider()) {
        self.urlProvider = urlProvider
    }

    func loadCurrentWeatherForMultipleCities(citiesIDs: [String]) -> AnyPublisher<[WeatherModel], Error> {
        guard let url = urlProvider.getCurrentWeatherLinkForMultipleCities(citiesIDs: citiesIDs) else {
            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Cities.self, decoder: jsonDecoder)
            .map { $0.list }
            .eraseToAnyPublisher()
    }

    func loadWeatherPrediction(coords: Coords) -> AnyPublisher<PredictionQuery, Error> {
        guard let url = urlProvider.getWeatherPredictionLink(with: coords) else {
            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PredictionQuery.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func loadCurrentWeather(byCityname city: String) -> AnyPublisher<WeatherModel, Error> {

        let cityName = city.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let url = urlProvider.getCurrentWeatherLink(cityName: cityName) else {
            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherModel.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func loadCurrentWeather(coords: CLLocationCoordinate2D) -> AnyPublisher<WeatherModel, Error> {
        guard let url = urlProvider.getCurrentWeatherLink(
                longitude: Float(coords.longitude),
                latitude: Float(coords.latitude)) else {

            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherModel.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
