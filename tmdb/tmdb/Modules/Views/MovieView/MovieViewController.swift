//
//  MovieViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit
import Kingfisher
import Alamofire

class MovieViewController: UIViewController {
    
    var movie: Movie?
    var isFavouriteMovie: Bool = false
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let movieData = movie else {
            print("Error with getting movie data")
            return
        }
        
        if let path = movieData.backdropPath {
            let url = URL(string: "\(DefaultValues.defaultImageUrl)\(path)")
            let placeholder = UIImage(named: "404")
            movieImage.kf.setImage(with: url, placeholder: placeholder)
        } else {
            movieImage.image = UIImage(named: "404")
            print("Error: backdrop_path is nil")
        }
        
        
        //        movieImage.kf.setImage(with: url)
        movieTitle.text = movieData.title ?? "error"
        voteAverage.text = "\(movieData.voteAverage ?? 0)"
        voteCount.text = "\(movieData.voteCount ?? 0)"
        movieDescription.text = movieData.overview ?? "error"
        date.text = movieData.releaseDate ?? "0"
        
        navigationController?.topViewController?.title = movieData.title
        
        // Создание кнопки 'Add to Favorites' с использованием системного изображения
        async {
            var isFavorite: Bool = false // Declare isFavorite outside the closure
            
            let isFavoriteResult = await withCheckedContinuation { continuation in
                isFavoriteMovieFunc(movie: movieData, page: 1) { result in
                    isFavorite = result // Assign the value inside the closure
                    print(isFavorite)
                    continuation.resume(returning: result)
                }
            }
            
            if isFavoriteResult {
                if let image = UIImage(systemName: "minus") {
                    let favoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(removeFromFavorites))
                    navigationItem.rightBarButtonItem = favoritesButton
                }
            } else if !isFavoriteResult {
                if let image = UIImage(systemName: "plus") {
                    let favoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToFavorites))
                    navigationItem.rightBarButtonItem = favoritesButton
                }
            }
        }
    }
}


extension MovieViewController {
    
    @objc func removeFromFavorites() {
        guard let movieData = movie else {
            print("Error with getting movie data")
            return
        }
        
        guard let userData = StorageService.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        let favoriteMovie: Parameters = [
            "media_type": "movie",
            "media_id": movieData.id!,
            "favorite": false
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            RequestClass.request(address: .getFavoriteMovies, params: .addRemoveFavoriteMovie(addRemoveMovieParams(requestType: .post, accountId: userData.userData.id, sessionId: userData.sessionId)), rawBody: favoriteMovie) { (response: Result<AddFavoriteMovieStruct, Error>) in
                switch response {
                case .success(let success):
                    print(success)
                    self.isFavouriteMovie = false
                    
                    if let image = UIImage(systemName: "plus") {
                        let favoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.addToFavorites))
                        self.navigationItem.rightBarButtonItem = favoritesButton
                    }
                    // Добавьте здесь вашу анимацию
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    @objc func addToFavorites() {
        
        if (!isFavouriteMovie) {
            guard let movieData = movie else {
                print("Error with getting movie data")
                return
            }
            
            guard let userData = StorageService.getUserData() else {
                print("Error with getting user data")
                return
            }
            
            let favoriteMovie: Parameters = [
                "media_type": "movie",
                "media_id": movieData.id!,
                "favorite": true
            ]
            
            
            RequestClass.request(address: .getFavoriteMovies, params: .addRemoveFavoriteMovie(addRemoveMovieParams.init(requestType: .post, accountId: userData.userData.id, sessionId: userData.sessionId)), rawBody: favoriteMovie) { (responce: Result<AddFavoriteMovieStruct, Error>) in
                switch responce {
                    
                case .success(let success):
                    print(success)
                    self.isFavouriteMovie = false
                    
                    if let image = UIImage(systemName: "minus") {
                        let favoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.addToFavorites))
                        self.navigationItem.rightBarButtonItem = favoritesButton
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            print("This movie is already in favorite list")
        }
    }
    
    func isFavoriteMovieFunc(movie: Movie, page: Int, completion: @escaping (Bool) -> Void) {
        
        var isFavorite: Bool = false
        
        guard let userData = StorageService.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        RequestClass.request(address: .getFavoriteMovies, params: .getFavoriteMoviesParam(.init(requestType: .get, sessionId: userData.sessionId, sortBy: "created_at.asc", page: page, language: "en-US", accountId: userData.userData.id))) { (responce: Result<FavoritesStruct, Error>) in
            
            switch responce {
            case .success(let result):
                result.results.forEach{ item in
                    if movie.id == item.id {
                        isFavorite = true
                    }
                }
                
                completion(isFavorite)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
