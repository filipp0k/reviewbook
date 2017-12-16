//
//  ReviewCell.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 16.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    @IBOutlet weak var LabelCell: UILabel!
    @IBOutlet weak var RatingCell: RatingControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
