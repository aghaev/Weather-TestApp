//
//  DetailedViewController.swift
//  Weather TestApp
//
//  Created by Mac on 5/30/22.
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
        maxTempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        minTempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        NSLayoutConstraint.activate([
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
}
