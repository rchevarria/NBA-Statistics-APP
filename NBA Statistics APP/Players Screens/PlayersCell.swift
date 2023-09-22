//
//  PlayersCell.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/13/22.
//

import UIKit

class PlayersCell: UITableViewCell {

    @IBOutlet weak var playersImage: UIImageView!
    @IBOutlet weak var playerTeamImage: UIImageView!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var basicInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
