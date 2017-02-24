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
    @IBOutlet var videoTitleTextView: UITextView!
    @IBOutlet var userThumbnailImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var uploadDateLabel: UILabel!
    var descriptionHeight: CGFloat! = 0
    var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionLabel = UILabel(frame: CGRect(x: CGFloat(descriptionLabelMargin), y: videoThumbnailImage.frame.origin.y + videoThumbnailImage.frame.size.height + CGFloat(descriptionLabelMargin), width: self.frame.size.width - 2*CGFloat(descriptionLabelMargin), height: CGFloat.greatestFiniteMagnitude))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        descriptionLabel.textColor = UIColor.lightGray
        self.addSubview(descriptionLabel)
        
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptionHeight = descriptionLabel.sizeThatFits(CGSize(width: descriptionLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        descriptionLabel.frame = CGRect(x: descriptionLabel.frame.origin.x, y: videoThumbnailImage.frame.origin.y + videoThumbnailImage.frame.size.height + CGFloat(descriptionLabelMargin), width: descriptionLabel.frame.size.width, height: descriptionHeight)
    }
}
