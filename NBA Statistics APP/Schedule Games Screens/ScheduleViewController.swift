//
//  ScheduleViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/21/22.
//

import UIKit
import Foundation

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate, SelectedScheduleDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var scheduleSearchBar: UISearchBar!
    
    var schedule = [NBA]()
    var scheduleFilteredData = [NBA]()
    
    var chosenSeason = "POST2022"   //default showing season
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleSearchBar.delegate = self
        
        reloading(year: chosenSeason)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        let scheduled = scheduleFilteredData[indexPath.row]
        
        if(scheduled.DateTime != nil){
            let dateString = String(scheduled.DateTime!)
            let dateFixed = dateString.replacingOccurrences(of: "T", with: " ")
    
            let date = getDateFormat(dateStrInTwentyFourHourFomat: dateFixed)
            cell.dateLabel.text = date!
            
            let time = getTimeFormat(dateStrInTwentyFourHourFomat: dateFixed)
            cell.timeLabel.text = String(time!.prefix(5))
            cell.PMam.text = String(time!.suffix(2))
        
        }
        else{
            cell.dateLabel.text = "Date Not Available"
        }
        
        let homeImg = scheduled.HomeTeamID!
        let homeImage = String(homeImg)
        cell.homeTeamImage.image = UIImage(named: homeImage)
        
        let visitorImg = scheduled.AwayTeamID!
        let visitorImage = String(visitorImg)
        cell.visitorTeamImage.image = UIImage(named: visitorImage)
        
        if scheduled.Status == "Scheduled"{
            cell.homeLabel.text = scheduled.HomeTeam
            cell.visitorLabel.text = scheduled.AwayTeam
        }
        else{
            if scheduled.HomeTeamScore != nil{
                let homeScore = String(scheduled.HomeTeamScore)
                cell.homeLabel.text = homeScore
            }
            if scheduled.AwayTeamScore != nil{
                let awayScore = String(scheduled.AwayTeamScore)
                cell.visitorLabel.text = awayScore
            }
        }
        
        if scheduled.Status == "Scheduled"{
            let bellStatus = UserDefaults.standard.string(forKey: "\(indexPath.row)")
            if bellStatus != nil{
                cell.bellImage.image = UIImage(named: "yesReminder")
            }
            else{
                cell.bellImage.image = UIImage(named: "noReminder")
            }
        }
        else{
            cell.bellImage.image = UIImage(named: "gameDone")
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    func downloadSeasonJSON(season: String, completed: @escaping () -> ()){
        print("Current Season: \(season)")
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/Games/\(String(describing: season ))?key=be59fbd8f83c4c038d8ca4cf7d536892")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.schedule = try JSONDecoder().decode([NBA].self, from: data!)
                    if(season == "POST2022"){
                        self.schedule = self.schedule.filter {$0.Status == "Scheduled"} //Filter by the games that have not been played yet Status = "Scheduled"
                    }
                    self.schedule = self.schedule.filter {$0.Status != "Canceled" || $0.Status != "Postponed" }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        scheduleFilteredData = []
        
        if searchText == ""{
            scheduleFilteredData = schedule
        }
        else{
            for teams in schedule{
                if teams.HomeTeam.lowercased().contains(searchText.lowercased()) || teams.AwayTeam.lowercased().contains(searchText.lowercased()) {
                    scheduleFilteredData.append(teams)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getTimeFormat(dateStrInTwentyFourHourFomat: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let newDate = dateFormatter.date(from: dateStrInTwentyFourHourFomat) {

            let timeFormat = DateFormatter()
            timeFormat.timeZone = TimeZone.autoupdatingCurrent
            timeFormat.locale = Locale(identifier: "en_US_POSIX")
            timeFormat.dateFormat = "hh:mm a"

            let requiredStr = timeFormat.string(from: newDate)
            return requiredStr
        } else {
            return nil
        }
    }
    
    func getDateFormat(dateStrInTwentyFourHourFomat: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let newDate = dateFormatter.date(from: dateStrInTwentyFourHourFomat) {

            let timeFormat = DateFormatter()
            timeFormat.timeZone = TimeZone.autoupdatingCurrent
            timeFormat.locale = Locale(identifier: "en_US_POSIX")
            timeFormat.dateFormat = "EEE, MMM dd, yyyy"

            let requiredStr = timeFormat.string(from: newDate)
            return requiredStr
        } else {
            return nil
        }
    }
    
    //Delegate protocol implementation
    func sendScheduleToScheduleViewController(yearString: String){
        var fixYearString = yearString
        if(fixYearString == "2022 Playoffs"){
            fixYearString = "POST2022"
        }
        else if(fixYearString == "2021 Playoffs"){
            fixYearString = "POST2021"
        }
        chosenSeason = fixYearString
        reloading(year: chosenSeason)
    }
    
    //Reloads the info to the season the user selects
    func reloading(year: String){
        if year != "POST2022"{
            self.tableView.allowsSelection = false
        }
        else{
            self.tableView.allowsSelection = true
        }
        downloadSeasonJSON(season: year){
            self.scheduleFilteredData = self.schedule
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AlertScheduleViewController{
            destination.gameDetails = scheduleFilteredData[(tableView.indexPathForSelectedRow?.row)!]
            destination.currentCellRow = tableView.indexPathForSelectedRow?.row
            destination.reloadLocally = {
                self.tableView.reloadData()
            }
        }
        if let destination = segue.destination as? SelectSchedule{
            destination.scheduleDelegate = self
        }
    }
}


