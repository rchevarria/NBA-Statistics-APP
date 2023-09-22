//
//  SelectScheduleViewController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 5/1/22.
//

import Foundation
import UIKit

protocol SelectedScheduleDelegate: AnyObject{
    func sendScheduleToScheduleViewController(yearString: String)
}

class SelectSchedule: UIViewController{
    
    var selectedYear = "2022 Playoffs"
    
    @IBOutlet weak var chooseSchedule: UIPickerView!
    
    weak var scheduleDelegate : SelectedScheduleDelegate?
    
    let years = ["2022 Playoffs", "2022", "2021 Playoffs", "2021"]
    
    
    override func viewDidLoad() {
        chooseSchedule.delegate = self
        chooseSchedule.dataSource = self
    }
    
    
    @IBAction func done(_ sender: Any) {
        scheduleDelegate?.sendScheduleToScheduleViewController(yearString: selectedYear)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

/*
 Resource for implementing a picker view
 https://www.youtube.com/watch?v=lICHh10y_XU
*/
extension SelectSchedule: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = years[row]
        
    }
}



