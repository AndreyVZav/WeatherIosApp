//
//  WeatherResponse.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
    let localtime: String
}

struct Current: Decodable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: Condition
}

struct Hour: Decodable {
    let time: String
    let temp_c: Double
    let condition: Condition
}
