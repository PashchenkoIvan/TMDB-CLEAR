//
//  MovieViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {
    
    var movie: Movie?
    var isFavouriteMovie: Bool = false
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var vote_average: UILabel!
    @IBOutlet weak var vote_count: UILabel!
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
        vote_average.text = "\(movieData.voteAverage ?? 0)"
        vote_count.text = "\(movieData.voteCount ?? 0)"
        movieDescription.text = movieData.overview ?? "error"
        date.text = movieData.releaseDate ?? "0"
        
        navigationController?.topViewController?.title = movieData.title
        
        // Создание кнопки 'Add to Favorites' с использованием системного изображения
        if let image = UIImage(systemName: "star") {
            let favoritesButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToFavorites))
            navigationItem.rightBarButtonItem = favoritesButton
        }
    }
    
    @objc func addToFavorites() {
        
        if (!isFavouriteMovie) {
            guard let movieData = movie else {
                print("Error with getting movie data")
                return
            }
            
            guard let userData = StaticMethodsClass.getUserData() else {
                print("Error with getting user data")
                return
            }
            
            StaticMethodsClass.request(address: Address.GetFavoriteMovies, params: Params.AddFavoriteMovie(AddMovieParams.init(requestType: .post, accountId: userData.userData.id, sessionId: userData.sessionId, mediaType: "movie", mediaId: movieData.id!, favorite: true))) { (responce: Result<AddFavoriteMovieStruct, Error>) in
                
                switch responce {
                    
                case .success(let success):
                    print(success)
                    self.isFavouriteMovie = true
                    
                    StaticMethodsClass.playCheckmarkAnimation(on: self.movieImage)
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            print("This movie is already in favorite list")
        }
    }
}


