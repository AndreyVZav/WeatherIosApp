//
//  LoadingView.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 13.05.2025.
//

import UIKit

final class LoadingView: UIActivityIndicatorView {
    init() {
        super.init(style: .large)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
