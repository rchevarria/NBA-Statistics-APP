//
//  AlertScheduleViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/21/22.
//

import UIKit
import UserNotifications


class AlertScheduleViewController: UITableViewController{
    
    var schedule = [NBA]()
    var gameDetails: NBA?
    
    var currentCellRow: Int?
    var reloadLocally : (()-> Void)?
    
    
    let userNotification =  UNUserNotificationCenter.current()
    
    @IBOutlet weak var gameStartAlert: UISwitch!
    @IBOutlet weak var oneDayAlert: UISwitch!
    @IBOutlet weak var oneHourAlert: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    /*
     Resources for notifications
     https://www.raywenderlich.com/21458686-local-notifications-getting-started
     https://stackoverflow.com/questions/40270598/ios-10-how-to-view-a-list-of-pending-notifications-using-unusernotificationcente
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(fullTeamName(keyName: (gameDetails?.HomeTeam)!)) vs. \(fullTeamName(keyName: (gameDetails?.AwayTeam)!)) "
        
        if let setdateLabel = gameDetails?.DateTime{
            let dateString = setdateLabel
            let dateFixed = dateString.replacingOccurrences(of: "T", with: " ")
    
            let date = getDateFormat(dateStrInTwentyFourHourFomat: dateFixed)
            dateLabel.text = date
        }
        else{
            dateLabel.text = "Date Not Available Yet"
        }
        
        //Game Start Alert
        userNotification.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == "\(String(describing: self.gameDetails?.GameID)) + started"{
                    DispatchQueue.main.async {
                        self.gameStartAlert.isOn = true
                    }
                }
                print(request.identifier)
            }
        })
        
        //One Day Alert
        userNotification.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == "\(String(describing: self.gameDetails?.GameID)) + oneDay"{
                    DispatchQueue.main.async {
                        self.oneDayAlert.isOn = true
                    }
                }
            }
        })
        
        //One Hour Alert
        userNotification.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == "\(String(describing: self.gameDetails?.GameID)) + oneHour"{
                    DispatchQueue.main.async {
                        self.oneHourAlert.isOn = true
                    }
                }
            }
        })
    }
    
    
    @IBAction func done(_ sender: Any) {
        //Using UserDefaults to remember if the user has notifications set to on or off
        if gameStartAlert.isOn == true || oneDayAlert.isOn == true || oneHourAlert.isOn == true{
            UserDefaults.standard.set("yesReminder", forKey: "\(currentCellRow!)")
        }
        else{
            UserDefaults.standard.removeObject(forKey: "\(currentCellRow!)")
        }
        
        self.reloadLocally?()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Game Started Alert, switch button, scheduling, removing
    
    //Switch for Game Started Alert
    @IBAction func shouldRemind(_ switchControl: UISwitch) {
        
        var dateFixed = "2000-01-01 00:00:00"
        if let dateTime = gameDetails?.DateTime{
            let dateString = dateTime
            dateFixed = (dateString.replacingOccurrences(of: "T", with: " "))
        }
                
        if switchControl.isOn == true{
            animationOn()
            scheduleNotification(dueDate: dateFixed)
        }
        else{
            animationOff()
            removeNotification()
        }
    }
    
    // Game Start Alerts
    func scheduleNotification(dueDate: String){
        
        let date = getDateFromString(dateStr: dueDate)
        let content = UNMutableNotificationContent()
        
        var homeTeamName = "HomeTeam"
        if let homeTeam = gameDetails?.HomeTeam{
            homeTeamName = homeTeam
        }
        var awayTeamName = "AwayTeam"
        if let awayTeam = gameDetails?.AwayTeam{
            awayTeamName = awayTeam
        }
            
        content.title = "Game is ON!"
        content.body = "\(fullTeamName(keyName: homeTeamName)) vs. \(fullTeamName(keyName: awayTeamName)) "
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "\(String(describing: gameDetails?.GameID)) + started" , content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error{
                print("Error is: \(error)")
            }
        })
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(String(describing: gameDetails?.GameID)) + started"])
    }
    
    // MARK: - One Day Game Alert, switch button, scheduling, removing
    
    //Switch for one day alert
    @IBAction func oneDayReminder(_ switchControl: UISwitch) {
        
        var dateFixed = "2000-01-01 00:00:00"
        if let dateTime = gameDetails?.DateTime{
            let dateString = dateTime
            dateFixed = (dateString.replacingOccurrences(of: "T", with: " "))
        }
     
        if switchControl.isOn == true{
            animationOn()
            scheduleOneDayNotification(dueDate: dateFixed)
        }
        else{
            animationOff()
            removeOneDayNotification()
        }
    }
    
    // One Day Alert
    func scheduleOneDayNotification(dueDate: String){
        
        let date = getDateFromString(dateStr: dueDate)
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: date!)
        
        let content = UNMutableNotificationContent()
        
        var homeTeamName = "HomeTeam"
        if let homeTeam = gameDetails?.HomeTeam{
            homeTeamName = homeTeam
        }
        var awayTeamName = "AwayTeam"
        if let awayTeam = gameDetails?.AwayTeam{
            awayTeamName = awayTeam
        }
        
        var dateString = "Date Not Available Yet"
        if let dateCheck = getTimeFormat(dateStrInTwentyFourHourFomat: dueDate){
            dateString = dateCheck
        }
            
        
        content.title = "\(fullTeamName(keyName: homeTeamName)) vs. \(fullTeamName(keyName: awayTeamName)) "
        content.body = "Tomorrow at \(dateString)!"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "\(String(describing: gameDetails?.GameID)) + oneDay" , content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error{
                print("Error is: \(error)")
            }
        })
    }
    
    func removeOneDayNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(String(describing: self.gameDetails?.GameID)) + oneDay"])
    }
    
    // MARK: - One Hour Game Alert, switch button, scheduling, removing
    
    //Switch for one hour alert
    @IBAction func oneHourReminder(_ switchControl: UISwitch) {
        
        var dateFixed = "2000-01-01 00:00:00"
        if let dateTime = gameDetails?.DateTime{
            let dateString = dateTime
            dateFixed = (dateString.replacingOccurrences(of: "T", with: " "))
        }
         
        if switchControl.isOn == true{
            animationOn()
            scheduleOneHourNotification(dueDate: dateFixed)
        }
        else{
            animationOff()
            removeOneHourNotification()
        }
    }
    
    // One Hour Alert
    func scheduleOneHourNotification(dueDate: String){
        
        let date = getDateFromString(dateStr: dueDate)
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: date!)
        
        let content = UNMutableNotificationContent()
        
        var homeTeamName = "HomeTeam"
        if let homeTeam = gameDetails?.HomeTeam{
            homeTeamName = homeTeam
        }
        var awayTeamName = "AwayTeam"
        if let awayTeam = gameDetails?.AwayTeam{
            awayTeamName = awayTeam
        }
            
        
        content.title = "Game Starting in 1 HOUR!"
        content.body = "\(fullTeamName(keyName: homeTeamName)) vs. \(fullTeamName(keyName: awayTeamName)) "
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "\(String(describing: gameDetails?.GameID)) + oneHour" , content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error{
                print("Error is: \(error)")
            }
        })
    }

    func removeOneHourNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(String(describing: self.gameDetails?.GameID)) + oneHour"])
    }
    
    
    // MARK: - Helper Functions -> notification animations, getDateFromString & fullTeamName
    
    func animationOn(){
        let hudView = HudView.hud(inView: view, animated: true)
        hudView.image = "bellOn"
        hudView.text = "Notification On"
        afterDelay(0.7) {
          hudView.hide()
        }
    }
    
    func animationOff(){
        let hudView = HudView.hud(inView: view, animated: true)
        hudView.image = "bellOff"
        hudView.text = "Notification Off"
        afterDelay(0.7) {
          hudView.hide()
        }
    }
    
    //Getting official dates from Strings
    func getDateFromString(dateStr: String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFromString = dateFormatter.date(from: dateStr)
        
        return dateFromString!
    }
    
    //30 team names
    func fullTeamName(keyName: String) -> String{
        if keyName == "WAS"{
            return "Wizards"
        }
        else if keyName == "CHA"{
            return "Hornets"
        }
        else if keyName == "ATL"{
            return "Hawks"
        }
        else if keyName == "MIA"{
            return "Heat"
        }
        else if keyName == "ORL"{
            return "Magic"
        }
        else if keyName == "NY"{
            return "Knicks"
        }
        else if keyName == "PHI"{
            return "76ers"
        }
        else if keyName == "BKN"{
            return "Nets"
        }
        else if keyName == "BOS"{
            return "Celtics"
        }
        else if keyName == "TOR"{
            return "Raptors"
        }
        else if keyName == "CHI"{
            return "Bulls"
        }
        else if keyName == "CLE"{
            return "Cavaliers"
        }
        else if keyName == "IND"{
            return "Pacers"
        }
        else if keyName == "DET"{
            return "Pistons"
        }
        else if keyName == "MIL"{
            return "Bucks"
        }
        else if keyName == "MIN"{
            return "Timberwolves"
        }
        else if keyName == "UTA"{
            return "Jazz"
        }
        else if keyName == "OKC"{
            return "Thunder"
        }
        else if keyName == "POR"{
            return "Trail Blazers"
        }
        else if keyName == "DEN"{
            return "Nuggets"
        }
        else if keyName == "MEM"{
            return "Grizzlies"
        }
        else if keyName == "HOU"{
            return "Rockets"
        }
        else if keyName == "NO"{
            return "Pelicans"
        }
        else if keyName == "SA"{
            return "Spurs"
        }
        else if keyName == "DAL"{
            return "Mavericks"
        }
        else if keyName == "GS"{
            return "Warriors"
        }
        else if keyName == "LAL"{
            return "Lakers"
        }
        else if keyName == "LAC"{
            return "Clippers"
        }
        else if keyName == "PHO"{
            return "Suns"
        }
        else if keyName == "SAC"{
            return "Kings"
        }
        else{
            return "NULL"
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
            timeFormat.dateFormat = "EEEE, MMMM dd, yyyy hh:mm a"

            let requiredStr = timeFormat.string(from: newDate)
            
            return requiredStr
        }
        else{
            return "not available"
        }
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

            var requiredStr = timeFormat.string(from: newDate)
            let prefixCase = "0"
            if requiredStr.hasPrefix(prefixCase){
                requiredStr.remove(at: requiredStr.startIndex)
            }
            
            return requiredStr
        }
        else{
            return "not available"
        }
    }
    
    func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(
        deadline: .now() + seconds,
        execute: run)
    }
}


