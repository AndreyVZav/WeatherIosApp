//
//  WeatherViewController.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()
    private let loadingView = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let currentWeatherView = CurrentWeatherView()
    private let hourlyForecastView = HourlyForecastView()
    private let dailyForecastView = DailyForecastView()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Погода"
        
        setupUI()
        bindViewModel()
        viewModel.requestLocation()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Добавляем в stackView нужные компоненты
        stackView.addArrangedSubview(currentWeatherView)
        stackView.addArrangedSubview(hourlyForecastView)
        stackView.addArrangedSubview(dailyForecastView)

        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        hourlyForecastView.translatesAutoresizingMaskIntoConstraints = false
        dailyForecastView.translatesAutoresizingMaskIntoConstraints = false

        hourlyForecastView.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] data in
            self?.loadingView.stopAnimating()
            self?.errorLabel.isHidden = true
            
            self?.currentWeatherView.configure(with: CurrentWeatherUIModel(
                city: data.location.name,
                temperature: "\(Int(data.current.temp_c))°C",
                conditionText: data.current.condition.text,
                iconPath: data.current.condition.icon
            ))
            
            // прогноз по часам
            let hourModels = data.forecast.forecastday.first?.hour.map {
                HourlyWeatherUIModel(
                    time: String($0.time.split(separator: " ").last ?? ""),
                    temperature: "\(Int($0.temp_c))°C",
                    iconPath: $0.condition.icon
                )
            } ?? []
            self?.hourlyForecastView.configure(with: hourModels)
            
            // Прогноз по дням
            let dayModels = data.forecast.forecastday.map {
                DailyWeatherUIModel(
                    date: $0.date,
                    maxTemp: "\(Int($0.day.maxtemp_c))°",
                    minTemp: "\(Int($0.day.mintemp_c))°",
                    iconPath: $0.day.condition.icon
                )
            }
            self?.dailyForecastView.configure(with: dayModels)
            print("Дней в forecast:", data.forecast.forecastday.count)
        }
        
        viewModel.onError = { [weak self] message in
            self?.loadingView.stopAnimating()
            self?.errorLabel.text = "Ошибка: \(message)\nПопробуйте еще раз."
            
        }
        
        loadingView.startAnimating()
    }
    
}
