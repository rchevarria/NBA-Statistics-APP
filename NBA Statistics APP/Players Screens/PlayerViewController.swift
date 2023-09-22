//
//  PlayerViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/13/22.
//

import UIKit

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
        

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var playerSearchBar: UISearchBar!
    
    var players = [NBA]()
    var playerFilteredData = [NBA]()
    var playerdetails:NBA?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerSearchBar.delegate = self
        downloadJSON{
            self.playerFilteredData = self.players
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayersCell", for: indexPath) as! PlayersCell
        let player = playerFilteredData[indexPath.row]
        
        cell.firstName.text = player.FirstName
        cell.lastName.text = player.LastName + ","
        
        if let posterPath = URL(string: player.PhotoUrl!){
            cell.playersImage.loadImage(url: posterPath)
        }
        else{
            cell.playersImage.image = UIImage(named: "avatar-placeholder")
        }
        
        var jersey = "\(String(describing: player.Jersey))"
        jersey = jersey.replacingOccurrences(of: "Optional(", with: "", options: NSString.CompareOptions.literal, range: nil)
        jersey = jersey.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let shortInfo = "\(String(player.Team))  |  #\(String(jersey))  |  \(String(player.PositionCategory))"
        
        cell.basicInfo.text = shortInfo
        
        let imgID = player.TeamID!
        let img = String(imgID)
        
        cell.playerTeamImage.image = UIImage(named: img)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/Players?key=be59fbd8f83c4c038d8ca4cf7d536892")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.players = try JSONDecoder().decode([NBA].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("JSON Error \(error)")
                }
            }
            else{
                print("Error")
            }
        }.resume()
    }
    
    /*
     Resource for implementing search bar
     https://www.youtube.com/watch?v=iH67DkBx9Jc
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        playerFilteredData = []
        
        if searchText == ""{
            playerFilteredData = players
        }
        else{
            for people in players{
                if people.FirstName.lowercased().contains(searchText.lowercased()) || people.LastName.lowercased().contains(searchText.lowercased()) {
                    playerFilteredData.append(people)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerDetailViewController{
            destination.playerdetails = playerFilteredData[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
