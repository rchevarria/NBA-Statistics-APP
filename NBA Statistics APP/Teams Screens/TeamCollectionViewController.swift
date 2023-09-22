//
//  TeamCollectionViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/8/22.
//

import UIKit
import AVFoundation

//key: be59fbd8f83c4c038d8ca4cf7d536892


class TeamCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var teamCollection: UICollectionView!
    
    var teams = [NBA]()
    var teamStats = [NBA]()
    var sound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAudio()
        downloadJSON { [self] in
            
            let layout = teamCollection.collectionViewLayout as! UICollectionViewFlowLayout
            
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
            
            layout.itemSize = CGSize(width: width, height: width)
             
            self.teamCollection.reloadData()
        }
  
        teamCollection.delegate = self
        teamCollection.dataSource = self

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = teamCollection.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
        let team = teams[indexPath.row]
        
        let imgID = team.TeamID!
        let img = String(imgID)
        
        cell.teamLogo.image = UIImage(named: img)
        return cell
    }
    
    
    /*
     Resource for loading data from API
     https://www.youtube.com/watch?v=lFE-TJJxxLU
     https://www.youtube.com/watch?v=FNkS_QIngg8&t=989s
    */
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: "https://api.sportsdata.io/v3/nba/scores/json/AllTeams?key=be59fbd8f83c4c038d8ca4cf7d536892")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.teams = try JSONDecoder().decode([NBA].self, from: data!)
                    self.teams = self.teams.filter {$0.TeamID <= 30}
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error with JSON \(error)")
                }
            }
        }.resume()
    }
    

    /*
     Resource for playing audio 
     https://stackoverflow.com/questions/43891532/playing-audio-from-a-selected-table-cell-stored-in-an-array-created-from-a-struc
    */
    func playAudio() {
        let url = Bundle.main.url(forResource: "StadiumChants", withExtension: "wav")!

        do {
            sound = try AVAudioPlayer(contentsOf: url)
            guard let sound = sound else { return }

            sound.prepareToPlay()
            sound.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = teamCollection.indexPath(for: cell){
            let item = teams[indexPath.row]
            let detailsViewController = segue.destination as? TeamDetailViewController
            detailsViewController?.teamdetails = item
            teamCollection.deselectItem(at: indexPath, animated: true)
        }
    }
    
}


