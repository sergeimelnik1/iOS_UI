//
//  ViewController.swift
//  AF_learn
//
//  Created by Sergey Melnik on 11.04.2022.
//

import Foundation
import Alamofire

class ViewController: UIViewController {
    
    struct Weather {
        var code = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("http://api.openweathermap.org/data/2.5/forecast?q=moscow&units=metric&appid=92cabe9523da26194b02974bfcd50b7e").responseJSON { response in
            print(response)
        }
        print("viewDidLoad ended")
        
        
    }
}
