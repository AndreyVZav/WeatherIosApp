//
//  CurrentWeatherView.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // настройка внешнего вида
        cityLabel.font = .systemFont(ofSize: 24, weight: .bold)
        temperatureLabel.font = .systemFont(ofSize: 48, weight: .semibold)
        conditionLabel.font = .systemFont(ofSize: 20)
        iconImageView.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, conditionLabel, iconImageView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with model: CurrentWeatherUIModel) {
        cityLabel.text = model.city
        temperatureLabel.text = model.temperature
        conditionLabel.text = model.conditionText
        
        if let url = URL(string: "https:\(model.iconPath)") {
            // Ленивая загрузка иконки
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.iconImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
