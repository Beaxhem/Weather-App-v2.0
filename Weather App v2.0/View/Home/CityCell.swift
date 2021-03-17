//
//  CityCell.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI

struct CityCell: View {

    let city: WeatherModel

    var body: some View {
        HStack {
            Text("\(Int(city.main.currentTemp.rounded()))°")
            Text(city.name)
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
    }
}
