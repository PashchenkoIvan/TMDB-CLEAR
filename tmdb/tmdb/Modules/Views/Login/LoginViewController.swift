//
//  ViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.05.2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var movieTextLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTextLabel.backgroundColor = UIColor.clear
        movieTextLabel.layer.borderColor = UIColor.white.cgColor
        movieTextLabel.layer.borderWidth = 2
    }

    @IBAction func buttonPressed(_ sender: Any) {
        if let username = loginTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty {
            RequestsStaticClass.loginUser(username: username, password: password) { response in
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(result) {
                            UserDefaults.standard.set(encodedData, forKey: "userData")
                            
                            // Создаем экземпляр TabBarController
                            let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                            
                            // Переходим на TabBarController
                            tabBarController.modalPresentationStyle = .fullScreen // Для открытия на весь экран
                            self.present(tabBarController, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Enter login or/and password")
        }
    }

    
}

