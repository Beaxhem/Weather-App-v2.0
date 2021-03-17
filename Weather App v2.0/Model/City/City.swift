//
//  City.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 14.03.2021.
//

import Foundation

class Cities: Codable {
    var list: [WeatherModel]
}

struct WeatherModel: Codable, Identifiable {
    var id: Int
    var name: String
    var main: Temperature
    var weather: [Weather]
    var sys: WeatherMeta
    var wind: Wind
    var coord: Coords
}

struct Weather: Codable {
    var title: String
    var description: String
    var iconName: String

    enum CodingKeys: String, CodingKey {
        case title = "main"
        case description
        case iconName = "icon"
    }
}

struct Temperature: Codable {
    var currentTemp: Float
    var minTemp: Float
    var maxTemp: Float
    var feelsLike: Float
    var pressure: Int
    var humidity: Int

    enum CodingKeys: String, CodingKey {
        case currentTemp = "temp"
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case pressure
        case humidity
    }
}

struct WeatherMeta: Codable {
    var sunrise: Int
    var sunset: Int
    var country: String
}

struct Wind: Codable {
    var speed: Float
    var degrees: Int

    private let directions: [Int: String] = [
        1: "N",
        2: "NNE",
        3: "NE",
        4: "ENE",
        5: "E",
        6: "ESE",
        7: "SE",
        8: "SSE",
        9: "S",
        10: "SSW",
        11: "SW",
        12: "WSW",
        13: "W",
        14: "WNW",
        15: "NW",
        16: "NNW",
        17: "N",
    ]

    var direction: String {
        let deg = degrees % 360 // in case the value is more than 360°
        let index = Int((Float(deg) / 22.5).rounded() + 1)

        return directions[index] ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}

struct Coords: Codable {
    var lon: Float
    var lat: Float
}
