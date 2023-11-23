import Foundation

import SwiftUI

class Helpers{
    
    let scoreTypes = ["1", "2", "3", "4", "5", "6","Times3", "Times4", "FullHouse", "Small", "Large", "Yahtzee", "Chance"]
    
    func isSmallScreenHeightDevice() -> Bool {
        let screenHeight = UIScreen.main.bounds.size.height
        return UIDevice.current.userInterfaceIdiom == .phone && screenHeight <= 667.0
    }
}

enum PlayerAuthState:String{
    case authenticating = "Logging in to Game Center..."
    case unauthenticated = "Please sign in the Game Center to play."
    case authenticated = ""
    case error = "There was an error logging into Game Center."
    case restricted = "You are not allowed to play multiplayer games!"
}

