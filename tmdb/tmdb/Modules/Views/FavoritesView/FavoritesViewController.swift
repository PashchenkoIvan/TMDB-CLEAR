//
//  FavoritesViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userData = StorageService.getUserData()
    var requestResponce: FavoritesStruct = FavoritesStruct(page: 0, results: [], totalPages: 0, totalResults: 0)
    var movieList: Array<Movie> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрация ячейки таблицы из Nib-файла
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceholderCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "Favorites";
        
        let page: Int = 1
        
        RequestClass.request(address: .getFavoriteMovies, params: .getFavoriteMoviesParam(.init(requestType: .get, sessionId: userData!.sessionId, sortBy: "created_at.asc", page: page, language: "en-US", accountId: userData!.userData.id))) { (responce: Result<FavoritesStruct, Error>) in
            
            switch responce {
            case .success(let result):
                
                self.requestResponce = result
                self.movieList = result.results
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.isEmpty ? 1 : movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movieList.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell", for: indexPath)
            
            cell.selectionStyle = .none
            cell.textLabel?.text = "Not found"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            cell.selectionStyle = .none
            
            if let backdropPath = movieList[indexPath.row].backdropPath {
                let imageUrl = "\(DefaultValues.defaultImageUrl)\(backdropPath)"
                cell.setImage(image: imageUrl)
            } else {
                // Установка изображения '404' или другого запасного изображения
                cell.cellImageView.image = UIImage(named: "imageNotFound")
            }
            
            cell.setTitle(title: movieList[indexPath.row].title ?? "No one movie with this name")
            
            return cell
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if movieList.count != 0 {
            // Получаем данные о фильме, связанные с выбранной ячейкой
            let movie = movieList[indexPath.row]
            
            // Создаем экземпляр MovieViewController
            let movieViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
            
            // Передаем данные о фильме в MovieViewController
            movieViewController.movie = movie
            
            // Открываем MovieViewController
            self.navigationController?.pushViewController(movieViewController, animated: true)
        }
    }
}
