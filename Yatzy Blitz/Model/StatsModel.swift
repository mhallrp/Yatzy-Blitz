import Foundation

class StatsModel{
    
    let store = NSUbiquitousKeyValueStore.default
    
    static let shared = StatsModel()
    
    func retrieveStat(value: String) -> Int{
        if let stat = store.object(forKey: value) as? Int{
            return stat
        } else {
            return 0
        }
    }
    
    func setStats(cat:String,value:Int){
        store.set(value, forKey: cat)
        store.synchronize()
    }
    
    func clearUserDataFromiCloud() {
        let keys = ["games", "won", "lost", "draw"]
        for key in keys {
            store.set(nil as Int?, forKey: key)
        }
        store.synchronize()
    }
}
