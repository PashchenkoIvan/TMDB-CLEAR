//
//  GenresViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.05.2024.
//

import UIKit
import Alamofire
import KeychainSwift
import Kingfisher

class GenresViewController: UIViewController {
    
    private var movieList:[Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting user data
        guard let userData: ReturnUserDataStruct = StorageService.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let buttonImage = UIImage(systemName: "rectangle.portrait.and.arrow.forward") {
            let logoutButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(logoutUser))
            navigationItem.rightBarButtonItem = logoutButton
        } 
        
        //Named this view in top navigation bar
        navigationController?.navigationBar.topItem?.title = "Genres";
        
        //Getting trending movies
        RequestClass.request(address: .getTrendMovies, params: .getTrendMovies(.init(requestType: .get, language: "en-US"))) { (responce: Result<TrendingMovieStruct, Error> ) in
            switch responce {
                
                //In case of success
            case .success(let result):
                
                self.movieList = result.results!
                self.collectionView.reloadData()
                
                //In case of error
            case .failure(let error):
                print("Error with getting trending movies")
                
            }
        }
    }
    
}

extension GenresViewController: UICollectionViewDataSource {
    
    //Count of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Return length of the movies array
        return movieList.count
    }
    
    //Cell settings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentMovie = movieList[indexPath.row]
        let url = URL(string: "\(DefaultValues.defaultImageUrl)\(currentMovie.backdropPath!)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.kf.setImage(with: url)
        cell.movieTitleLabel.text = currentMovie.title
        cell.voteAverageLabel.text = "\(currentMovie.voteAverage!)"
        cell.voteCountLabel.text = "\(currentMovie.voteCount!)"
        cell.dateLabel.text = currentMovie.releaseDate
        
        return cell
    }
    
    
}

extension GenresViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension GenresViewController {
    @objc func logoutUser () {
        
        guard let userData = StorageService.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        let rawBody: Parameters = [
            "session_id": userData.sessionId
        ]
        
        let keychain = KeychainSwift()
        
        RequestClass.request(address: .deleteSession, params: .deleteSession(.init(requestType: .delete)), rawBody: rawBody) { (responce: Result<DeleteSession, Error>) in
            switch responce {
            case .success(let result):
                
                print(result)
                keychain.delete("userData")
                
                exit(0)
                
            case .failure(let error):
                print("Error with deleting session: \(error)")
            }
        }
    }
}
