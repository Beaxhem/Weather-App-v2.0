//
//  DetailedWeatherView.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI

struct DetailedWeatherView: View {

    let city: WeatherModel

    let viewModel = DetailedWeatherViewModel()

    init(city: WeatherModel) {
        self.city = city

        viewModel.fetchPredictions(coords: city.coord)
    }

    var body: some View {
        VStack(alignment: .center) {
            header
            Divider()
            predictions

            Spacer()
        }
    }

    var header: some View {
        VStack(alignment: .center) {
            Text(city.name)
                .font(.title2)

            Text(city.weather.first?.title ?? "")

            Text("\(Int(city.main.currentTemp.rounded()))°")
                .font(.title)

            HStack(alignment: .center) {
                Text("Max: \(Int(city.main.maxTemp.rounded()))")
                Text("Min: \(Int(city.main.minTemp.rounded()))")
            }
        }
        .padding()
    }

    var predictions: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.predictions, id: \.dt) { prediction in
                    makePredictionCell(prediction: prediction)
                }
            }
        }
        .frame(height: 100)
    }
}

private extension DetailedWeatherView {

    func makePredictionCell(prediction: Prediction) -> some View {
        VStack {
            HStack {
                Text("\(Int(prediction.temp.day.rounded()))°")

                Text("\(Int(prediction.temp.night.rounded()))°")
            }

            Text(prediction.date)
        }
        .padding(.horizontal)
    }
}
