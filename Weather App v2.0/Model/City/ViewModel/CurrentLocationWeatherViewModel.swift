//
//  CurrentLocationWeatherViewModel.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import SwiftUI
import Combine
import CoreLocation

class CurrentLocationWeatherViewModel: NSObject, ObservableObject {

    @Published var localWeather: WeatherModel?

    private var currentLocation: CLLocation? {
        didSet {
            fetchWeather()
        }
    }

    private let locationManager = CLLocationManager()

    private let weatherService: WeatherService

    private var cancellable = Set<AnyCancellable>()

    init(weatherService: WeatherService = WeatherManager()) {

        self.weatherService = weatherService

        super.init()

        setupLocation()
        fetchWeather()
    }
}

private extension CurrentLocationWeatherViewModel {

    func fetchWeather() {

        if let location = currentLocation {

            weatherService.loadCurrentWeather(coords: location.coordinate)
                .receive(on: RunLoop.main)
                .sink { status in
                    switch status {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            break
                    }
                } receiveValue: { city in
                    self.localWeather = city
                }
                .store(in: &cancellable)

        }
    }

    func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
}

extension CurrentLocationWeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
