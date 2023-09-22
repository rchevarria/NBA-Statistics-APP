//
//  ScheduleCellTableViewCell.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/21/22.
//

import UIKit

class ScheduleCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var visitorTeamImage: UIImageView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var visitorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var PMam: UILabel!
    
    @IBOutlet weak var bellImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
