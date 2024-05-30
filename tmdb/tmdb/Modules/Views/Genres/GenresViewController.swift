//
//  GenresViewController.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.05.2024.
//

import UIKit
import Kingfisher

class GenresViewController: UIViewController {
    
    private var movieList:[Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting user data
        guard let userData: ReturnUserDataStruct = StaticMethodsClass.getUserData() else {
            print("Error with getting user data")
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Named this view in top navigation bar
        navigationController?.navigationBar.topItem?.title = "Genres";
        
        //Getting trending movies
        RequestClass.request(address: .GetTrendMovies, params: .GetTrendMovies(.init(requestType: .get, language: "en-US"))) { (responce: Result<TrendingMovieStruct, Error> ) in
            switch responce {
                
                //In case of success
            case .success(let result):
                result.results.forEach { movie in
                    self.movieList.append(movie)
                    self.collectionView.reloadData()
                }
                
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
        let url = URL(string: "\(DefaultValues.defaultImageUrl)\(currentMovie.backdrop_path!)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.kf.setImage(with: url)
        cell.movieTitleLabel.text = currentMovie.title
        cell.vote_averageLabel.text = "\(currentMovie.vote_average!)"
        cell.vote_countLabel.text = "\(currentMovie.vote_count!)"
        cell.dateLabel.text = currentMovie.release_date
        
        return cell
    }
    
    
}

extension GenresViewController: UICollectionViewDelegate {
    
}
