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
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        weatherImage.tintColor = .black
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20),
            weatherImage.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 110),
            maxTempLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 200),
            minTempLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 250),
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            weatherImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        print("NSLayoutConstraint.activate")
        
        
    }
}
