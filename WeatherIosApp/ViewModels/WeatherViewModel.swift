//
//  WeatherViewModel.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import Foundation
import CoreLocation

final class WeatherViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    var onUpdate: ((WeatherResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func fetchWeather(lat: Double, lon: Double) {
        weatherService.fetchWeather(for: CLLocationCoordinate2D(latitude: lat, longitude: lon)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.onUpdate?(data)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            onError?("Не удалось получить геопозицию")
            return
        }
        fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Москва как fallback
        fetchWeather(lat: 55.7558, lon: 37.6173)
    }
}
