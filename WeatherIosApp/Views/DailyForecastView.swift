//
//  DailyForecastView.swift
//  WeatherIosApp
//
//  Created by Андрей Завадский on 12.05.2025.
//

import UIKit

final class DailyForecastView: UIView, UITableViewDataSource {
    
    private var models: [DailyWeatherUIModel] = []
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.register(DailyForecastCell.self, forCellReuseIdentifier: "DailyForecastCell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.dataSource = self
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with models: [DailyWeatherUIModel]) {
        self.models = models
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.tableView.layoutIfNeeded()
            let height = self.tableView.contentSize.height
            self.tableViewHeightConstraint.constant = height
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastCell", for: indexPath) as? DailyForecastCell else {
            return UITableViewCell()
        }
        cell.configure(with: models[indexPath.row])
        return cell
    }
}
