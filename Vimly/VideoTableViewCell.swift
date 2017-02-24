//
//  VideoTableViewCell.swift
//  Vimly
//
//  Created by Apple on 2/24/17.
//  Copyright © 2017 Chisel Cut Solutions. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet var videoThumbnailImage: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var userThumbnailImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var uploadDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
