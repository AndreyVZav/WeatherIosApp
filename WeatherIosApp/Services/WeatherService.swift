//
//  WeatherService.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import Foundation
import CoreLocation

final class WeatherService {
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    
    func fetchWeather(for location: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&days=7&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty Data", code: -1)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
