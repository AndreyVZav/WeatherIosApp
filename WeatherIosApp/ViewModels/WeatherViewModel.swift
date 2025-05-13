//
//  WeatherViewModel.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import CoreLocation

final class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    var onUpdate: ((WeatherResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    private var didRequest = false
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else {
            // Пользователь запретил — используем Москву
            fetchWeatherForMoscow()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            fetchWeatherForMoscow()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка геолокации: \(error)")
        fetchWeatherForMoscow()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !didRequest else { return }
        didRequest = true
        if let location = locations.first?.coordinate {
            weatherService.fetchWeather(for: location) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.onUpdate?(response)
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        } else {
            fetchWeatherForMoscow()
        }
    }
    
    private func fetchWeatherForMoscow() {
        let moscowCoordinates = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        weatherService.fetchWeather(for: moscowCoordinates) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.onUpdate?(response)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
