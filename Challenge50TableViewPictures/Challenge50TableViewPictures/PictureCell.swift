//
//  PictureCell.swift
//  Challenge50TableViewPictures
//
//  Created by Noah Glaser on 12/30/21.
//

import UIKit

class PictureCell: UITableViewCell {

    @IBOutlet var pictureName: UILabel!
    @IBOutlet var pictureImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
