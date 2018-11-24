//
//  HourlyWeatherViewControllerCollectionViewCell.swift
//  Weather wear
//
//  Created by Joel Beilis on 2018-11-22.
//  Copyright © 2018 Joel Beilis. All rights reserved.
//

import UIKit

class HourlyWeatherViewControllerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView?
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
