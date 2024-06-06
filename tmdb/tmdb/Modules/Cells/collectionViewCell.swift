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
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
