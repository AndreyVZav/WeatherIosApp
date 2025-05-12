//
//  WeatherViewControllerWrapper.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import SwiftUI

struct WeatherViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WeatherViewController {
        return WeatherViewController()
    }

    func updateUIViewController(_ uiViewController: WeatherViewController, context: Context) {
        // обновления не нужны
    }
}
