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
    
    
    
    static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy HH.mm"
            return df
        }()
    
    func configure(whithWeather weather: Weather) {
            let date = Date(timeIntervalSince1970: weather.date)
            let stringDate = WeatherCell.dateFormatter.string(from: date)
            
            self.weather.text = String(weather.temp)
            time.text = stringDate
            icon.image = UIImage(named: weather.weatherIcon)
        }

}
