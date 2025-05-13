//
//  WeatherViewController.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()
    
    private let contentView = WeatherContentView()
    private let loadingView = LoadingView()
    private let errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Погода"
        
        setupUI()
        bindViewModel()
        viewModel.requestLocation()
    }
    
    private func setupUI() {
        [contentView, loadingView, errorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        
        errorView.isHidden = true
        contentView.isHidden = true
        loadingView.startAnimating()
        
        errorView.onRetry = { [weak self] in
            self?.errorView.isHidden = true
            self?.loadingView.startAnimating()
            self?.viewModel.requestLocation()
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] data in
            guard let self else { return }
            self.loadingView.stopAnimating()
            self.errorView.isHidden = true
            self.contentView.isHidden = false
            
            self.contentView.currentWeatherView.configure(with: CurrentWeatherUIModel(
                city: data.location.name,
                temperature: "\(Int(data.current.temp_c))°C",
                conditionText: data.current.condition.text,
                iconPath: data.current.condition.icon
            ))
            
            let now = Date()
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: now)
            let todayHours = data.forecast.forecastday.first?.hour.filter {
                let hour = Int($0.time.split(separator: " ").last?.prefix(2) ?? "") ?? 0
                return hour >= currentHour
            } ?? []
            let tomorrowHours = data.forecast.forecastday.count > 1 ? data.forecast.forecastday[1].hour : []
            let combinedHours = todayHours + tomorrowHours
            
            let hourModels = combinedHours.map {
                HourlyWeatherUIModel(
                    time: String($0.time.split(separator: " ").last ?? ""),
                    temperature: "\(Int($0.temp_c))°C",
                    iconPath: $0.condition.icon
                )
            }
            self.contentView.hourlyForecastView.configure(with: hourModels)
            
            let dayModels = data.forecast.forecastday.map {
                DailyWeatherUIModel(
                    date: $0.date,
                    maxTemp: "\(Int($0.day.maxtemp_c))°",
                    minTemp: "\(Int($0.day.mintemp_c))°",
                    iconPath: $0.day.condition.icon
                )
            }
            self.contentView.dailyForecastView.configure(with: dayModels)
        }
        
        viewModel.onError = { [weak self] message in
            self?.loadingView.stopAnimating()
            self?.contentView.isHidden = true
            self?.errorView.label.text = "Ошибка: \(message)\nПопробуйте ещё раз."
            self?.errorView.isHidden = false
        }
    }
    
    
}
