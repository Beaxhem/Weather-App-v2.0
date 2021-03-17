//
//  Prediction.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 16.03.2021.
//

import Foundation

struct PredictionQuery: Codable {
    var daily: [Prediction]
}

struct Prediction: Codable {

    var dt: Int
    var temp: PredictionTemperature
    var weather: [Weather]

    var date: String {
        let date = Date(timeIntervalSince1970: Double(dt))
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            return "\(Calendar.current.component(.day, from: date))"
        }
    }
}

struct PredictionTemperature: Codable {
    var night: Float
    var day: Float
}
