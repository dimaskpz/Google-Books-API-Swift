//
//  BookCell.swift
//  List Book Apps 2
//
//  Created by dimas pratama on 23/01/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class BookCell: UITableViewCell {

    @IBOutlet weak var bookDescription: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var authorsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookDescription.layer.cornerRadius = 5
        cosmosView.settings.fillMode = .precise
        cosmosView.settings
        .updateOnTouch = false
        
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
