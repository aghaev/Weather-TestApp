//
//  DetailedViewController.swift
//  Weather TestApp
//
//  Created by Aydin Aghayev on 5/30/22.
//

import UIKit

struct DetailedView {
    
    var stackView = UIStackView()
    var dateLabel = UILabel()
    var weatherImage = UIImageView()
    var maxTempLabel = UILabel()
    var minTempLabel = UILabel()
    
    func setConstraints() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        weatherImage.tintColor = .black
        weatherImage.contentMode = .scaleAspectFit
        dateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dateLabel.textAlignment = .center
        maxTempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        maxTempLabel.textAlignment = .center
        minTempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        minTempLabel.textAlignment = .center
        
        
        NSLayoutConstraint.activate([
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
}
