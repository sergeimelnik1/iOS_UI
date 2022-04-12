//
//  MyCityesController.swift
//  Open Weather UI Learn
//
//  Created by Sergey Melnik on 06.04.2022.
//

import UIKit
import Alamofire
import RealmSwift

class MyCityesController: UITableViewController {
    
    var cityes: Results<City>?
    var token: NotificationToken?
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAddCityForm()
    }
    
    func addCity(name: String) {
        let newCity = City()
        newCity.name = name.uppercased()
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(newCity, update: .all)
            try realm.commitWrite()
            print(realm.configuration.fileURL)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddCity"), object: nil)
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        // отправим запрос для получения погоды для Москвы
        //            weatherService.loadWeatherData(city: cityName)
        pairTableAndRealm()
    }
    //тут всплывашка
    func showAddCityForm() {
        let alertController = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        })
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
            guard let name = alertController.textFields?[0].text else { return }
            self?.addCity(name: name)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: {  })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCityesCell", for: indexPath) as! MyCityesCell
        // получаем город для конкретной строки
        let city = cityes?[indexPath.row]
        // устанавливаем город в надпись ячейки
        cell.cityName.text = city?.name
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let city = cityes?[indexPath.row]
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(city!.weathers)
                realm.delete(city!)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController", let cell = sender as? UITableViewCell {
            let ctrl = segue.destination as! WeatherViewController
            if let indexPath = tableView.indexPath(for: cell) {
                ctrl.cityName = cityes?[indexPath.row].name ?? ""
            }
        }
    }
    
    @objc func addCities() {
        guard let realm = try? Realm() else { return }
        cityes = realm.objects(City.self)
        tableView.reloadData()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        cityes = realm.objects(City.self)
        NotificationCenter.default.addObserver(self, selector: #selector(addCities), name: NSNotification.Name(rawValue: "AddCity"), object: nil)
        
        token = realm.observe( { [unowned self] note, realm in
            switch note {
            case .didChange:
                tableView.reloadData()
                break
            case .refreshRequired:
                tableView.beginUpdates()
                break
            }
            self.tableView.reloadData()
        })
    }
}
