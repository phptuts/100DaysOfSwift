//
//  FlagTableViewCell.swift
//  Day23ChallengeProject
//
//  Created by Noah Glaser on 12/3/21.
//

import UIKit

class FlagTableViewCell: UITableViewCell {

    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
