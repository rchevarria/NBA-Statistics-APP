//
//  SportsData.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/8/22.
//

import Foundation

struct NBA:Codable{
    
    // Team Info
    var TeamID : Int!
    var Name: String!
    var WikipediaLogoUrl: String!
    var PrimaryColor: String!
    var Conference: String!
    var Division : String!
    var City: String!
    var Key: String!
    
    // Team Season Info
    var Wins: Int!
    var Losses: Int!
    var Games: Int!
    
    // Player Info
    var PlayerID: Int!
    var FirstName: String!
    var LastName: String!
    var PhotoUrl: String!
    var Team: String!
    var Jersey: Int!
    var PositionCategory: String!
    var Position : String!
    var Height: Int!
    var BirthDate: String!
    var BirthCity: String!
    var Experience: Int!
    
    //Player Season Stat Info
    var Points: Double!
    var TwoPointersMade: Double!
    var ThreePointersMade: Double!
    var Minutes: Double!
    var FreeThrowsMade : Double!
    var Assists: Double!
    var Steals: Double!
    var BlockedShots: Double!
    
    // Scheduled Games Info
    var Status: String!
    var AwayTeam: String!
    var HomeTeam: String!
    var DateTime: String!
    var HomeTeamID: Int!
    var AwayTeamID: Int!
    var GameID: Int!
    
    var AwayTeamScore: Int!
    var HomeTeamScore: Int!
    
}

// All resource citations ->
/*
    Resource used to fix the navigation bar appearance
    https://developer.apple.com/documentation/technotes/tn3106-customizing-uinavigationbar-appearance

    Resource used for utilizing UserDefaults to remember the last tab bar
    https://stackoverflow.com/questions/1623234/how-to-remember-last-selected-tab-in-uitabbarcontroller
 
    Resource for loading data from API
    https://www.youtube.com/watch?v=lFE-TJJxxLU
    https://www.youtube.com/watch?v=FNkS_QIngg8&t=989s
 
    Resource for playing audio
    https://stackoverflow.com/questions/43891532/playing-audio-from-a-selected-table-cell-stored-in-an-array-created-from-a-struc
 
    Resource for retrieving hex from a string
    https://jike.in/qa/?qa=896194/
 
    Resource for implementing search bar
    https://www.youtube.com/watch?v=iH67DkBx9Jc
 
    Resources for notifications
    https://www.raywenderlich.com/21458686-local-notifications-getting-started
    https://stackoverflow.com/questions/40270598/ios-10-how-to-view-a-list-of-pending-notifications-using-unusernotificationcente
 
    Resource for implementing a picker view
    https://www.youtube.com/watch?v=lICHh10y_XU
 
    Other resources:
 
    iOS CodePath.org course
    https://courses.codepath.com/sessions
    
    Textbook
    https://www.raywenderlich.com/books/uikit-apprentice
*/
