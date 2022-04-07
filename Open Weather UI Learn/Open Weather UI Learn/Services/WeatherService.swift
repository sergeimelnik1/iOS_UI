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

class WeatherService {
    
    //сохранение погодных данных в realm
    func saveWeatherData(_ weathers: [Weather]) {
        // обработка исключений при работе с хранилищем
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            
            // начинаем изменять хранилище
            realm.beginWrite()
            
            // кладем все объекты класса погоды в хранилище
            realm.add(weathers)
            
            // завершаем изменять хранилище
            try realm.commitWrite()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    // базовый url сервиса
    let baseUrl = "http://api.openweathermap.org"
    // ключ для доступа к сервису
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
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
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print(repsonse.value as Any)
        }
        
        AF.request(url,
                   method: .get,
                   parameters: parameters).responseData { [weak self] repsons in
            guard let data = repsons.value else { return }

            let json = JSON(data: data)
            
            let weathers = json["list"].compactMap { Weather(json: $0.1) }
            self?.saveWeatherData(weathers)
            
            completion(weathers)
        }
    }
}
