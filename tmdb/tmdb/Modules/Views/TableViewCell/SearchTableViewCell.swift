//
//  SearchTableViewCell.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    func setImage (image: String) {
        let url = URL(string: image)
        cellImageView.kf.setImage(with: url)
    }
    
    func setTitle (title: String) {
        cellTitleLabel.text = title
    }
}
