//
//  WeatherViewController.swift
//  Open Weather UI Learn
//
//  Created by Sergey Melnik on 06.04.2022.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    // создаем экземпляр сервиса
    let weatherService = WeatherService()
    let dateFormatter = DateFormatter()
    var cityName = ""
    var weathers: [Weather] = []
    var cityes: Results<City>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadWeathers(notification:)), name: NSNotification.Name(rawValue: "LoadWeathers"), object: nil)
            
        self.overrideUserInterfaceStyle = .light
        self.collectionView.dataSource = self
        //запрос на получение погоды из выбранного города
        weatherService.loadWeatherData(city: cityName)
    }
    
    @objc func loadWeathers(notification: Notification) {
        if let weathers = notification.object as? [Weather] {
            self.weathers = weathers
            collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let weather = weathers[indexPath.row]
        
        cell.weather.text = "\(String(describing: weather.temp)) C"
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        let date = Date(timeIntervalSince1970: weather.date )
        let stringDate = dateFormatter.string(from: date)
        cell.time.text = stringDate
        
        cell.icon.image = UIImage(named: weather.weatherIcon )
        return cell
    }
}
