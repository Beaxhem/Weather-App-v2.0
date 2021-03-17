//
//  URLProvider.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 16.03.2021.
//

import Foundation

protocol URLProvider {
    func getCurrentWeatherLink(cityName: String) -> URL?
    func getCurrentWeatherLink(longitude: Float, latitude: Float) -> URL?

    func getCurrentWeatherLinkForMultipleCities(citiesIDs: [String]) -> URL?
    func getWeatherPredictionLink(with coords: Coords) -> URL?
}

class OpenWeatherURLProvider: URLProvider {
    private let apiKey = Secrets.openWeatherAPIKey
    private let host = "https://api.openweathermap.org/data/2.5"

    func getCurrentWeatherLink(cityName: String) -> URL? {
        let api = host + "/weather?q=\(cityName)&units=metric&appid=\(apiKey)"

        return encodeURL(rawURL: api)
    }

    func getCurrentWeatherLinkForMultipleCities(citiesIDs: [String]) -> URL? {
        let api = host + "/group?id=\(citiesIDs.joined(separator: ","))&units=metric&appid=\(apiKey)"

        return encodeURL(rawURL: api)
    }

    func getWeatherPredictionLink(with coords: Coords) -> URL? {
        let api = host + "/onecall?lat=\(coords.lat)&lon=\(coords.lon)&exclude=current,minutely,hourly,alerts&units=metric&appid=\(apiKey)"

        return encodeURL(rawURL: api)
    }

    func getCurrentWeatherLink(longitude: Float, latitude: Float) -> URL? {
        let api = host + "/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"

        return encodeURL(rawURL: api)
    }

    func encodeURL(rawURL: String) -> URL? {
        guard let encodedURL = rawURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        return URL(string: encodedURL)
    }
}

