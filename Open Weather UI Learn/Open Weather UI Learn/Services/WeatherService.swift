//
//  WeatherService.swift
//  Open Weather UI Learn
//
//  Created by Sergey Melnik on 06.04.2022.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class City: Object {
    @objc dynamic var name = ""
    var weathers: [Weather] = []
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

class WeatherService {
    
    
    // базовый url сервиса
    let baseUrl = "http://api.openweathermap.org"
    // ключ для доступа к сервису
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    var weathers: [Weather] = []
    
    // метод для загрузки данных, в качестве аргументов получает город
    
    // метод для загрузки данных, в качестве аргументов получает город
    func loadWeatherData(city: String){
        
        // путь для получения погоды за 5 дней
        let path = "/data/2.5/forecast"
        // параметры, город, единицы измерения градусы, ключ для доступа к сервису
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        
        // составляем url из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path
        
        // делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] repsons in
            do {
                guard let data = repsons.value else { return }
                let json = try JSON(data: data)
                
                let weathers = json["list"].compactMap { Weather(json: $0.1, city: city) }
                
                self?.saveWeatherData(weathers, city: city)
        
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadWeathers"), object: weathers)
                
            } catch {
                print(error)
            }
        }
    }

    // сохранение погодных данных в realm
    func saveWeatherData(_ weathers: [Weather], city: String) {
        // обработка исключений при работе с хранилищем
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            // получаем город
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            // все старые погодные данные для текущего города
            let oldWeathers = city.weathers
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldWeathers)
            // кладем все объекты класса погоды в хранилище
            city.weathers.append(contentsOf: weathers)
            // завершаем изменять хранилище
            try realm.commitWrite()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
}
