//
//  WeatherContentView.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 13.05.2025.
//

import UIKit

final class WeatherContentView: UIView {
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let currentWeatherView = CurrentWeatherView()
    let hourlyForecastView = HourlyForecastView()
    let dailyForecastView = DailyForecastView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        stackView.addArrangedSubview(currentWeatherView)
        stackView.addArrangedSubview(hourlyForecastView)
        stackView.addArrangedSubview(dailyForecastView)
        
        hourlyForecastView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        dailyForecastView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
}
