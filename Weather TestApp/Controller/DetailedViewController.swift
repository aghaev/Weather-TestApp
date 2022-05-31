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
            weatherImage.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 80),
            maxTempLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 190),
            minTempLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 290),
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
//            weatherImage.widthAnchor.constraint(equalToConstant: 15)
        ])
        print("NSLayoutConstraint.activate")
    }
}
