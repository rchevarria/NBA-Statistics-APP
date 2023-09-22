//
//  PlayerDetailViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/25/22.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    var players = [NBA]()
    var playerdetails:NBA?
    var playerSeasonDetails:NBA?
    
    //PlayerBackground Info
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var shortDescripLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var birthCityLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var yearsPlayedLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    //PlayerSeason Info
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var twoPointersLabel: UILabel!
    @IBOutlet weak var threePointersLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    @IBOutlet weak var freeThrowsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var stealsLabel: UILabel!
    @IBOutlet weak var blocksLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Player Background info
        
        downloadJSONBackground { [self] in
            firstNameLabel.text = playerdetails?.FirstName
            lastNameLabel.text = playerdetails?.LastName
            birthCityLabel.text = playerdetails?.BirthCity
            birthDateLabel.text = playerdetails?.BirthDate
            
            if(playerdetails?.BirthDate != nil){
                let dateString = playerdetails?.BirthDate!
                let dateFixed = dateString!.replacingOccurrences(of: "T", with: " ")
        
                let date = getDateFormat(dateStrInTwentyFourHourFomat: dateFixed)
                birthDateLabel.text = date!
            }
            else{
                birthDateLabel.text = "Date Not Available"
            }
            
            
            if playerdetails?.Position == "SF"{
                positionLabel.text = "Small Forward (SF)"
            }
            else if playerdetails?.Position == "C"{
                positionLabel.text = "Center (C)"
            }
            else if playerdetails?.Position == "PG"{
                positionLabel.text = "Point Guard (PG)"
            }
            else if playerdetails?.Position == "PF"{
                positionLabel.text = "Point Forward (PF)"
            }
            else if playerdetails?.Position == "SG"{
                positionLabel.text = "Shooting Guard (SG)"
            }
            else{
                positionLabel.text = playerdetails?.Position
            }
            
            let feet = ((playerdetails?.Height!)!) / 12
            let inches = ((playerdetails?.Height!)!) - (feet * 12)
            let height = "\(String(feet))\' \(String(inches))\""
            heightLabel.text = height
            
            let experience = (playerdetails?.Experience!)!
            let experienceString = "\(String(experience)) years"
            
            if(playerdetails?.Experience != nil) {
                yearsPlayedLabel.text = experienceString
            }
            else{
                yearsPlayedLabel.text = "Not available"
            }
            
            if let posterPath = URL(string: (playerdetails?.PhotoUrl!)!){
                playerImage.loadImage(url: posterPath)
            }
            else{
                playerImage.image = UIImage(named: "avatar-placeholder")
            }
            
            var jersey = "\(String(describing: playerdetails?.Jersey))"
            jersey = jersey.replacingOccurrences(of: "Optional(", with: "", options: NSString.CompareOptions.literal, range: nil)
            jersey = jersey.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let playerTeam = (playerdetails?.Team!)!
            let playerPositionCategory = (playerdetails?.PositionCategory!)!
            let shortInfo = "\(String(playerTeam))  |  #\(String(jersey))  |  \(String(playerPositionCategory))"
            
            shortDescripLabel.text = shortInfo
            
        }
        
        downloadJSONSeason { [self] in
            //Points
            let points = (playerSeasonDetails?.Points!)!
            let pointString = "\(String(points))"
            totalPointsLabel.text = pointString
            
            //Two Pointers
            let twoPointers = (playerSeasonDetails?.TwoPointersMade!)!
            let twoPointersString = "\(String(twoPointers))"
            twoPointersLabel.text = twoPointersString
            
            //Three Pointers
            let threePointers = (playerSeasonDetails?.ThreePointersMade!)!
            let threePointersString = "\(String(threePointers))"
            threePointersLabel.text = threePointersString
            
            //Minutes Played
            let minutesPlayed = (playerSeasonDetails?.Minutes!)!
            let minutesPlayedString = "\(String(minutesPlayed))"
            playingTimeLabel.text = minutesPlayedString
            
            //Free Throws
            let freeThrows = (playerSeasonDetails?.FreeThrowsMade!)!
            let freeThrowsString = "\(String(freeThrows))"
            freeThrowsLabel.text = freeThrowsString
            
            //Assists
            let assists = (playerSeasonDetails?.Assists!)!
            let assistsString = "\(String(assists))"
            assistsLabel.text = assistsString
            
            //Steals
            let steals = (playerSeasonDetails?.Steals!)!
            let stealsString = "\(String(steals))"
            stealsLabel.text = stealsString
            
            //Blocks
            let blocks = (playerSeasonDetails?.BlockedShots!)!
            let blocksString = "\(String(blocks))"
            blocksLabel.text = blocksString
        }
    }
    
  
    
    func downloadJSONBackground(completed: @escaping () -> ()){
        let playerIDNUM = playerdetails?.PlayerID
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/Player/\(String(describing: playerIDNUM!))?key=be59fbd8f83c4c038d8ca4cf7d536892")
      
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.playerdetails = try JSONDecoder().decode(NBA.self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error: \(error)")
                }
            }
            else{
                print("Error")
            }
        }.resume()
    }
    
    func downloadJSONSeason(completed: @escaping () -> ()){
        let playerIDNUM = playerdetails?.PlayerID
        let url = URL(string: "https://api.sportsdata.io/v3/nba/stats/json/PlayerSeasonStatsByPlayer/2022/\(String(describing: playerIDNUM!))?key=be59fbd8f83c4c038d8ca4cf7d536892")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.playerSeasonDetails = try JSONDecoder().decode(NBA.self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error: \(error)")
                }
            }
            else{
                print("Error")
            }
        }.resume()
    }
    
    /*
     Resource for getting correct date format
     https://stackoverflow.com/questions/40807072/how-to-get-current-time-in-12-hour-format/50679548
    */
    func getDateFormat(dateStrInTwentyFourHourFomat: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let newDate = dateFormatter.date(from: dateStrInTwentyFourHourFomat) {

            let timeFormat = DateFormatter()
            timeFormat.timeZone = TimeZone.autoupdatingCurrent
            timeFormat.locale = Locale(identifier: "en_US_POSIX")
            timeFormat.dateFormat = "MMMM dd, yyyy"

            let requiredStr = timeFormat.string(from: newDate)
            return requiredStr
        } else {
            return nil
        }
    }
     

}

