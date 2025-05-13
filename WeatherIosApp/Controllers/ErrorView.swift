//
//  ErrorView.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 13.05.2025.
//

import UIKit

final class ErrorView: UIView {
    let label = UILabel()
    let button = UIButton(type: .system)
    
    var onRetry: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        
        button.setTitle("Повторить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        
        addSubview(label)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc private func didTapRetry() {
        onRetry?()
    }
}
