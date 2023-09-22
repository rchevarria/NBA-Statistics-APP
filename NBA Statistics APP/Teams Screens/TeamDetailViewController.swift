//
//  TeamDetailViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 5/1/22.
//

import UIKit

class TeamDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var teamdetails: NBA?
    var players = [NBA]()
    var teamSeasonDetails = [NBA]()
    
    //Team header outlets
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var shortBackgroundColor: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var cityTeamLabel: UILabel!
    @IBOutlet weak var conferenceLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    
    //Season Outlets
    
    @IBOutlet weak var winlossLabel: UILabel!
    @IBOutlet weak var totalGamesLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    //Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
        downloadJSON{
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
            
        let backGroundColor = teamdetails?.PrimaryColor!
        let colorBackground = String(describing: backGroundColor!)
        shortBackgroundColor.backgroundColor = colorWithHexString(hexString: colorBackground)
        
        if let imgID = teamdetails?.TeamID{
            let img = String(describing: imgID)
            teamLogo.image = UIImage(named: img)
        }
        
        if let cityName = teamdetails?.City{
            let city = String(describing: cityName)
            cityTeamLabel.text = city
        }
        
        if let teamName = teamdetails?.Name{
            let teamNBA = String(describing: teamName)
            teamNameLabel.text = teamNBA
        }
        
        if let conferenceName = teamdetails?.Conference{
            let conference = "\(String(describing: conferenceName)) conference"
            conferenceLabel.text = conference
        }
        
        if let divisionName = teamdetails?.Division{
            let division = "\(String(describing: divisionName)) division"
            divisionLabel.text = division
        }
        
        downloadSeasonJSON { [self] in
            if let wins = teamSeasonDetails[0].Wins, let losses = teamSeasonDetails[0].Losses {
                let winLoss = "\(String(describing: wins)) - \(String(describing: losses))"
                winlossLabel.text = winLoss
            }
            
            if let games = teamSeasonDetails[0].Games{
                let gameNum = "\(String(describing: games))"
                totalGamesLabel.text = gameNum
            }
            
            if let points = teamSeasonDetails[0].Points{
                let pointsNum = "\(String(describing: points))"
                totalPointsLabel.text = pointsNum
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayerCell", for: indexPath) as! TeamPlayerCell
        let player = players[indexPath.row]
        
        cell.firstNameLabel.text = player.FirstName
        cell.lastNameLabel.text = player.LastName + ","
        
        if let posterPath = URL(string: player.PhotoUrl!){
            cell.playerImage.loadImage(url: posterPath)
        }
        else{
            cell.playerImage.image = UIImage(named: "avatar-placeholder")
        }
        
        var jersey = "\(String(describing: player.Jersey))"
        jersey = jersey.replacingOccurrences(of: "Optional(", with: "", options: NSString.CompareOptions.literal, range: nil)
        jersey = jersey.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let shortInfo = "\(String(player.Team))  |  #\(String(jersey))  |  \(String(player.PositionCategory))"
        
        cell.shortDescrip.text = shortInfo
        
        let imgID = player.TeamID!
        let img = String(imgID)
        cell.teamLogo.image = UIImage(named: img)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let teamKey = teamdetails?.Key
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/Players/\(String(describing: teamKey!))?key=be59fbd8f83c4c038d8ca4cf7d536892")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.players = try JSONDecoder().decode([NBA].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            }
            else{
                print("Error")
            }
        }.resume()
    }
    
    func downloadSeasonJSON(completed: @escaping () -> ()){
        let teamKey = teamdetails?.Key
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/TeamSeasonStats/2022?key=be59fbd8f83c4c038d8ca4cf7d536892")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.teamSeasonDetails = try JSONDecoder().decode([NBA].self, from: data!)
                    self.teamSeasonDetails = self.teamSeasonDetails.filter {$0.Team == teamKey}
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            }
            else{
                print("Error")
            }
        }.resume()
    }
    
    /*
     Resource for retrieving hex from a string
     https://jike.in/qa/?qa=896194/
    */
    func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "(subString)(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerDetailViewController{
            destination.playerdetails = players[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
}
