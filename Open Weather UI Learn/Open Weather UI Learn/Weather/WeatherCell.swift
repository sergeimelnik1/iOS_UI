//
//  WeatherCell.swift
//  Open Weather UI Learn
//
//  Created by Sergey Melnik on 06.04.2022.
//

import UIKit
import Alamofire

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
}
