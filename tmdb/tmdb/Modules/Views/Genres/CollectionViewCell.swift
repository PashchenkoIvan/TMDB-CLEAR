//
//  CollectionViewCell.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var vote_averageLabel: UILabel!
    @IBOutlet weak var vote_countLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
