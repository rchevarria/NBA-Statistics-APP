//
//  TeamPlayerCell.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 5/4/22.
//

import UIKit

class TeamPlayerCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var shortDescrip: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
