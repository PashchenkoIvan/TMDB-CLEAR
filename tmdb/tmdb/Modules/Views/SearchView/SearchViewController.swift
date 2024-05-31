//
//  SearchViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let userData = StaticMethodsClass.getUserData()
    var resultData: Array<Movie> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрация ячейки таблицы из Nib-файла
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceholderCell")

        
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.isEmpty ? 1 : resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resultData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Ничего не найдено"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            cell.selectionStyle = .none
            
            if let backdropPath = resultData[indexPath.row].backdrop_path {
                let imageUrl = "\(DefaultValues.defaultImageUrl)\(backdropPath)"
                cell.setImage(image: imageUrl)
            } else {
                // Установка изображения '404' или другого запасного изображения
                cell.cellImageView.image = UIImage(named: "imageNotFound")
            }
            
            cell.setTitle(title: resultData[indexPath.row].title ?? "Название неизвестно")
            
            return cell
        }
    }



    
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if resultData.count != 0 {
            // Получаем данные о фильме, связанные с выбранной ячейкой
            let movie = resultData[indexPath.row]
            
            // Создаем экземпляр MovieViewController
            let movieViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
            
            // Передаем данные о фильме в MovieViewController
            movieViewController.movie = movie
            
            // Открываем MovieViewController
            self.navigationController?.pushViewController(movieViewController, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            RequestClass.request(address: .searchMovie, params: .searchMovie(.init(requestType: .get, query: searchText))) { (responce: Result<FavoritesStruct, Error>) in
                switch responce {
                case .success(let result):
                    self.resultData.removeAll()
                    
                    result.results.forEach { movie in
                        self.resultData.append(movie)
                    }
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error with search: \(error)")
                }
            }
        }
    }
}
