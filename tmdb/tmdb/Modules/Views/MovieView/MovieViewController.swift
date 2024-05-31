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
        
        let url = URL(string: "\(DefaultValues.defaultImageUrl)\(movieData.backdrop_path!)")
        
        movieImage.kf.setImage(with: url)
        movieTitle.text = movieData.title
        vote_average.text = "\(movieData.vote_average!)"
        vote_count.text = "\(movieData.vote_count!)"
        movieDescription.text = movieData.overview
        date.text = movieData.release_date
        
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
            
            RequestClass.request(address: Address.GetFavoriteMovies, params: Params.AddFavoriteMovie(AddMovieParams.init(requestType: .post, account_id: userData.user_data.id, session_id: userData.session_id, media_type: "movie", media_id: movieData.id!, favorite: true))) { (responce: Result<AddFavoriteMovieStruct, Error>) in
                
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


