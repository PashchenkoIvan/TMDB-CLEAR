//
//  GenresViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.05.2024.
//

import UIKit
import Kingfisher

class GenresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userData: ReturnUserDataStruct = StaticMethodsClass.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        RequestClass.request(address: .GetTrendMovies, params: .GetTrendMovies(.init(requestType: .get, language: "en-US"))) { (responce: Result<TrendingMovieStruct, Error> ) in
            switch responce {
                
            case .success(let result):
                print(result)
                
            case .failure(let error):
                print("Error with getting trending movies")
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "Genres"
    }

}
