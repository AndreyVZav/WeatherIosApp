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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Погода"
        
        setupUI()
        bindViewModel()
        viewModel.requestLocation()
    }
    
    private func setupUI() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(currentWeatherView)
        view.addSubview(loadingView)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            currentWeatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        }
        
        viewModel.onError = { [weak self] message in
            self?.loadingView.stopAnimating()
            self?.errorLabel.text = "Ошибка: \(message)\nПопробуйте еще раз."
        }
        
        loadingView.startAnimating()
    }
}
