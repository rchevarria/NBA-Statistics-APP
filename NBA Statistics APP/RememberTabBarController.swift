//
//  RememberTabBarController.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/28/22.
//

import Foundation
import UIKit

/*
 Resource used for utilizing UserDefaults to remember the last tab bar
 https://stackoverflow.com/questions/1623234/how-to-remember-last-selected-tab-in-uitabbarcontroller
*/

class RememberTabBarController: UITabBarController, UITabBarControllerDelegate{
    let selectedTabIndexKey = "selectedTabIndex"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if UserDefaults.standard.object(forKey: self.selectedTabIndexKey) != nil{
            self.selectedIndex = UserDefaults.standard.integer(forKey: self.selectedTabIndexKey)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UserDefaults.standard.set(self.selectedIndex, forKey: self.selectedTabIndexKey)
            UserDefaults.standard.synchronize()
        }
}
